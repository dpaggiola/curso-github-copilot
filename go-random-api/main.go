package main

import (
	"crypto/rand"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"math/big"
	"net/http"

	_ "go-random-api/docs"

	httpSwagger "github.com/swaggo/http-swagger"
)

type Response struct {
	Result interface{} `json:"result"`
}

// @title Random API
// @version 1.0
// @description This is a sample server for random data.
// @host localhost:8080
// @BasePath /
func main() {
	http.HandleFunc("/random/number", randomNumberHandler)
	http.HandleFunc("/random/string", randomStringHandler)
	http.HandleFunc("/random/uuid", randomUUIDHandler)

	http.HandleFunc("/swagger/", httpSwagger.WrapHandler)

	fmt.Println("Server starting on port 8080...")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		fmt.Printf("Error starting server: %s\n", err)
	}
}

// randomNumberHandler godoc
// @Summary Get a random number
// @Description Get a random number between 0 and 1000
// @Tags random
// @Produce  json
// @Success 200 {object} Response
// @Router /random/number [get]
func randomNumberHandler(w http.ResponseWriter, r *http.Request) {
	n, _ := rand.Int(rand.Reader, big.NewInt(1000))
	jsonResponse(w, n.Int64())
}

// randomStringHandler godoc
// @Summary Get a random string
// @Description Get a random string of 10 bytes (hex encoded)
// @Tags random
// @Produce  json
// @Success 200 {object} Response
// @Router /random/string [get]
func randomStringHandler(w http.ResponseWriter, r *http.Request) {
	bytes := make([]byte, 10)
	if _, err := rand.Read(bytes); err != nil {
		http.Error(w, "Internal Server Error", http.StatusInternalServerError)
		return
	}
	jsonResponse(w, hex.EncodeToString(bytes))
}

// randomUUIDHandler godoc
// @Summary Get a random UUID
// @Description Get a random UUID
// @Tags random
// @Produce  json
// @Success 200 {object} Response
// @Router /random/uuid [get]
func randomUUIDHandler(w http.ResponseWriter, r *http.Request) {
	b := make([]byte, 16)
	_, _ = rand.Read(b)
	uuid := fmt.Sprintf("%x-%x-%x-%x-%x",
		b[0:4], b[4:6], b[6:8], b[8:10], b[10:])
	jsonResponse(w, uuid)
}

func jsonResponse(w http.ResponseWriter, data interface{}) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(Response{Result: data})
}
