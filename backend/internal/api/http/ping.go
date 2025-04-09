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
)

type PingHandler struct {
	service usecases.Ping
}

func NewHandlerPing(ping usecases.Ping) *PingHandler {
	return &PingHandler{ping}
}

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

}
