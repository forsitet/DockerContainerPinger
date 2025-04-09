package http

import (
	"back/domain"
	"back/internal/api/http/types"
	"back/usecases"
	"encoding/json"
	"errors"
	"log"
	"net/http"
	"strconv"
	"time"

	"github.com/go-chi/chi/v5"
)

type PingHandler struct {
	service usecases.Ping
}

func NewHandlerPing(ping usecases.Ping) *PingHandler {
	return &PingHandler{ping}
}

// @Summary      Get a list of containers
// @Description  Returns a certain number of containers from the database (100 by default)
// @Tags         Ping
// @Produce      json
// @Param		 limit query int false "количество контейнеров"
// @Success      200  {array}  []domain.Ping
// @Failure      400  {object}  types.ErrorResponse
// @Failure      500  {object}  types.ErrorResponse
// @Router       /api/pings [get]
func (h *PingHandler) GetPing(w http.ResponseWriter, r *http.Request) {
	const op = "internal.api.http.GetPing"
	limit := 100
	req, err := types.CreateGetHandlerReq(r, "limit")
	if err != nil {
		if errors.Is(err, types.MissingKey) {
			h.limitHandler(w, limit)
			return
		} else {
			log.Println(op, err)
			types.CreateResponse(w,
				types.NewErrorResponse(err, http.StatusInternalServerError))
			return
		}
	}

	limit, err = strconv.Atoi(req.Key)
	if err != nil {
		log.Println(op, err)
		types.CreateResponse(w,
			types.NewErrorResponse(errors.New("bad request"), http.StatusBadRequest))
	}
	h.limitHandler(w, limit)

}

func (h *PingHandler) limitHandler(w http.ResponseWriter, limit int) {
	const op = "internal.api.http.limitHandler"
	result, err := h.service.GetPingResults(limit)
	if err != nil {
		log.Println(op, err)
		types.CreateResponse(w,
			types.NewErrorResponse(err, http.StatusInternalServerError))
	} else {
		types.CreateResponse(w, result)
	}
}

// @Summary      Saves and updates data in the database about containers
// @Description  Retrieves data from Kafka from the 'ping' topic
// @Tags         Ping
// @Accept       json
// @Param        ping  body  domain.Ping  true "JSON ping"
// @Success      201  {object}  domain.Ping
// @Failure      400  {object}  types.ErrorResponse
// @Failure      500  {object}  types.ErrorResponse
// @Router       /api/ping [post]
func (h *PingHandler) PostPing(w http.ResponseWriter, r *http.Request) {
	const op = "internal.api.http.PostPing"
	var ping *domain.Ping
	if err := json.NewDecoder(r.Body).Decode(&ping); err != nil {
		log.Println(op, err)
		types.CreateResponse(w,
			types.NewErrorResponse(err, http.StatusBadRequest))
		return
	}

	err := h.service.InsertPingResult(*ping)
	if err != nil {
		types.CreateResponse(w,
			types.NewErrorResponse(err, http.StatusInternalServerError))
		return
	}
	types.CreateResponse(w, http.StatusCreated)
}

// @Summary      Delete containers from the database after the 'before' date
// @Description  Deletes outdated containers
// @Tags         Ping
// @Param        before  path  time.Time  true  "'before' must be in the format RFC3339"
// @Success      204  "Удалено"
// @Failure      400  {object}  types.ErrorResponse
// @Failure      500  {object}  types.ErrorResponse
// @Router       /api/pings/old [delete]
func (h *PingHandler) DeleteOldPing(w http.ResponseWriter, r *http.Request) {
	const op = "internal.api.http.DeleteOldPing"
	req, err := types.CreateGetHandlerReq(r, "before")
	if err != nil {
		log.Println(op, err)
		types.CreateResponse(w,
			types.NewErrorResponse(errors.New("the 'before' parameter is required and must be in the format RFC3339"), http.StatusBadRequest))
	}

	rawBefore := req.Key
	before, err := time.Parse(time.RFC3339, rawBefore)
	if err != nil {
		log.Println(op, err)
		types.CreateResponse(w,
			types.NewErrorResponse(errors.New("invalid format of the 'before' parameter, expected RFC3339"), http.StatusBadRequest))
	}

	if err := h.service.DeleteOldPingResult(before); err != nil {
		log.Println(op, err)
		types.CreateResponse(w,
			types.NewErrorResponse(err, http.StatusInternalServerError))
	}

	types.CreateResponse(w, http.StatusNoContent)

}

func (h *PingHandler) WithObjectHandlers(r chi.Router) {
	r.Route("/api", func(r chi.Router) {
		r.Get("/pings", h.GetPing)
		r.Post("/ping", h.PostPing)
		r.Delete("/pings/old", h.DeleteOldPing)
	})
}
