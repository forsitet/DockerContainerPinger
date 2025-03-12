package handlersUser

import (
    "backend/service/errors"
    "net/http"
    "encoding/json"
    "backend/service"
    "backend/domain"
)

type LoginRequest struct {
    Username string `json:"username"`
    Password string `json:"password"`
}

type LoginResponse struct {
    User  *domain.User `json:"user"`
}

func Login(w http.ResponseWriter, r *http.Request) {
    var req LoginRequest
    if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
        http.Error(w, "Invalid request body", http.StatusBadRequest)
        return
    }

    // Вызов сервиса для проверки логина и пароля
    user, err := service.Authenticate(req.Username, req.Password)
    if err != nil {
        if err == errors.ErrInvalidCredentials {
            http.Error(w, "Invalid credentials", http.StatusUnauthorized)
        } else {
            http.Error(w, "Internal server error", http.StatusInternalServerError)
        }
        return
    }
        response := LoginResponse{User: user}
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(response)

}