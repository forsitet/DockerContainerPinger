package handlersUser

import (
	"backend/errors"
	"backend/internal/api/http/types"
	"backend/service"
	"encoding/json"
	"net/http"
)

type Handler struct {
	authService *service.AuthService
}

func NewHandler(authService *service.AuthService) *Handler {
	return &Handler{authService: authService}
}

func (h *Handler) Login(w http.ResponseWriter, r *http.Request) {
	var req types.LoginRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		types.CreateResponse(w, http.StatusBadRequest, types.ErrorResponse{
			Code:    http.StatusBadRequest,
			Message: "Invalid request body",
		})
		return
	}

	user, err := h.authService.Authenticate(req.Username, req.Password)
	if err != nil {
		if err == errors.ErrInvalidCredentials {
			types.CreateResponse(w, http.StatusUnauthorized, types.ErrorResponse{
				Code:    http.StatusUnauthorized,
				Message: "Invalid credentials",
			})
		} else {
			types.CreateResponse(w, http.StatusInternalServerError, types.ErrorResponse{
				Code:    http.StatusInternalServerError,
				Message: "Internal server error",
			})
		}
		return
	}

	types.CreateResponse(w, http.StatusOK, types.LoginResponse{User: user})
}
