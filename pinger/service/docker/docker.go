package docker

import (
	"context"
	"strings"

	"pinger/domain/model"
	"pinger/domain/repository"
	"pinger/domain/service"

	"github.com/docker/docker/api/types"
	"github.com/docker/docker/api/types/container"
	dockerClient "github.com/docker/docker/client"
)

type dockerRepository struct {
	client service.DockerClient
}

// New создает новый репозиторий с клиентом по умолчанию
func New() (repository.DockerRepository, error) {
	cli, err := dockerClient.NewClientWithOpts(
		dockerClient.FromEnv,
		dockerClient.WithVersion("1.47"),
	)
	if err != nil {
		return nil, err
	}

	return NewWithClient(cli), nil
}

func NewWithClient(client service.DockerClient) repository.DockerRepository {
	return &dockerRepository{
		client: client,
	}
}

func (r *dockerRepository) GetContainerInfos(ctx context.Context) (map[string]model.ContainerInfo, error) {
	containers, err := r.client.ContainerList(ctx, container.ListOptions{})
	if err != nil {
		return nil, err
	}

	results := make(map[string]model.ContainerInfo)
	for _, cntr := range containers {
		results[cntr.ID] = convertToContainerInfo(cntr)
	}

	return results, nil
}

func (r *dockerRepository) Close() error {
	return r.client.Close()
}

func convertToContainerInfo(cntr types.Container) model.ContainerInfo {
	var name string
	if len(cntr.Names) > 0 {
		name = strings.TrimPrefix(cntr.Names[0], "/")
	} else {
		name = cntr.ID[:12]
	}

	var ips []string
	if cntr.NetworkSettings != nil {
		for _, netSettings := range cntr.NetworkSettings.Networks {
			if netSettings.IPAddress != "" {
				ips = append(ips, netSettings.IPAddress)
			}
		}
	}

	return model.ContainerInfo{
		ID:   cntr.ID,
		Name: name,
		IPs:  ips,
	}
}