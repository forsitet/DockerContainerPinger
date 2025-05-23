package tests

import (
	"back/domain"
	"back/usecases/service"
	"back/internal/repository/postgres/mocks"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

func TestInMemoryRepo_WithoutMutex(t *testing.T) {
	repo := mocks.NewInMemoryRepo()
	service := service.NewServicePing(repo)
	now := time.Now()
	ping1 := domain.Ping{ID: 1, IPAddress: "82.179.176.252", ContainerName: "MIET", PingTime: 12.32, LastSuccess: now}
	ping2 := domain.Ping{ID: 2, IPAddress: "84.200.179.252", ContainerName: "SPINTex", PingTime: 15.42, LastSuccess: now.Add(-48 * time.Hour)}

	err := service.InsertPingResult(ping1)
	assert.NoError(t, err)

	err = service.InsertPingResult(ping2)
	assert.NoError(t, err)

	list, err := service.GetPingResults(10)
	assert.NoError(t, err)
	assert.Len(t, list, 2)

	err = service.DeleteOldPingResult(now.Add(-24 * time.Hour))
	assert.NoError(t, err)

	list, err = service.GetPingResults(10)
	assert.NoError(t, err)
	assert.Len(t, list, 1)
	assert.Equal(t, uint(1), list[0].ID)
}
