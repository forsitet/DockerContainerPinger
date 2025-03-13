// package handlersUser

// import (
// 	"encoding/json"
// 	"net/http"
// 	"backend/service"
// 	"backend/internal/api/http/types"
// )

// func Login(w http.ResponseWriter, r *http.Request) {
//     var req LoginRequest
//     if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
//         http.Error(w, "Invalid request body", http.StatusBadRequest)
//         return
//     }

//     user, err := service.Authenticate(req.Username, req.Password)
//     if err != nil {
//         if err == errors.ErrInvalidCredentials {
//             http.Error(w, "Invalid credentials", http.StatusUnauthorized)
//         } else {
//             http.Error(w, "Internal server error", http.StatusInternalServerError)
//         }
//         return
//     }
//         response := LoginResponse{User: user}
//     w.Header().Set("Content-Type", "application/json")
//     json.NewEncoder(w).Encode(response)

// }

package handlersUser

import (
	"encoding/json"
	"net/http"
    "backend/errors"
    "backend/service"
	"backend/internal/api/http/types"
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