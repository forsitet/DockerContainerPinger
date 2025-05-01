package docker

import (
	"context"
	"testing"

	"github.com/docker/docker/api/types"
	"github.com/docker/docker/api/types/network"
	"pinger/domain/model"

	"github.com/stretchr/testify/assert"
)

func TestGetContainerInfos(t *testing.T) {
	tests := []struct {
		name       string
		containers []types.Container
		want       map[string]model.ContainerInfo
		wantErr    bool
	}{
		{
			name: "success with single container",
			containers: []types.Container{
				{
					ID:    "abc123",
					Names: []string{"/my-container"},
					NetworkSettings: &types.SummaryNetworkSettings{
						Networks: map[string]*network.EndpointSettings{
							"bridge": {IPAddress: "172.17.0.2"},
						},
					},
				},
			},
			want: map[string]model.ContainerInfo{
				"abc123": {
					ID:   "abc123",
					Name: "my-container",
					IPs:  []string{"172.17.0.2"},
				},
			},
			wantErr: false,
		},
		{
			name: "container without name should use ID prefix",
			containers: []types.Container{
				{
					ID:    "abcdef123456",
					Names: []string{},
					NetworkSettings: &types.SummaryNetworkSettings{
						Networks: map[string]*network.EndpointSettings{
							"bridge": {IPAddress: "172.17.0.3"},
						},
					},
				},
			},
			want: map[string]model.ContainerInfo{
				"abcdef123456": {
					ID:   "abcdef123456",
					Name: "abcdef123456"[:12],
					IPs:  []string{"172.17.0.3"},
				},
			},
			wantErr: false,
		},
		{
			name:       "empty list should return empty map",
			containers: []types.Container{},
			want:       map[string]model.ContainerInfo{},
			wantErr:    false,
		},
		{
			name:       "error from Docker API",
			containers: nil,
			want:       nil,
			wantErr:    true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			mockClient := &MockDockerClient{
				Containers: tt.containers,
				Err:        nil,
			}
			if tt.wantErr {
				mockClient.Err = assert.AnError
			}

			repo := &dockerRepository{client: mockClient}
			got, err := repo.GetContainerInfos(context.Background())

			if tt.wantErr {
				assert.Error(t, err)
				assert.Nil(t, got)
			} else {
				assert.NoError(t, err)
				assert.Equal(t, tt.want, got)
			}
		})
	}
}