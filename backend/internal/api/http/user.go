	package user

import (
	"back/internal/api/http/types"
	"back/service"
	"encoding/json"
	"net/http"
)

type UserHandler struct {
	authService *service.AuthService
}

func NewUserHandler(authService *service.AuthService) *UserHandler {
	return &UserHandler{authService: authService}
}


// @Summary      Аутентификация пользователя
// @Description  Проверяет пользователя в базе данных
// @Tags         user
// @Accept       json
// @Produce      json
// @Param        user body domain.User true "Данные пользователя"
// @Success      200  {string} string
// @Failure      400  {string} string "Bad request"
// @Failure      401  {string} string "Unauthorized"
// @Failure      404  {string} string "key not found"
// @Router       /login [post]
func (h *UserHandler) Login(w http.ResponseWriter, r *http.Request) {
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
			types.CreateResponse(w, http.StatusUnauthorized, types.ErrorResponse{
				Code:    http.StatusUnauthorized,
				Message: "Invalid credentials",
			})
            return
		}
		
	types.CreateResponse(w, http.StatusOK, types.LoginResponse{User: user})
}
