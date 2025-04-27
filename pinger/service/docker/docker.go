package docker

import (
	"context"
	"strings"

	"pinger/domain/model"
	"pinger/domain/repository"

	"github.com/docker/docker/api/types"
	"github.com/docker/docker/api/types/container"
	dockerClient "github.com/docker/docker/client"
)

type Client struct {
    cli DockerInterface
}

type DockerInterface interface {
	ContainerList(ctx context.Context, options container.ListOptions) ([]types.Container, error)
	Close() error
}

func New() (repository.DockerRepository, error) {
    cli, err := dockerClient.NewClientWithOpts(
        dockerClient.FromEnv,
        dockerClient.WithVersion("1.47"),
    )
    if err != nil {
        return nil, err
    }

    return &Client{cli: cli}, nil
}

func (c *Client) GetContainerInfos(ctx context.Context) (map[string]model.ContainerInfo, error) {
    containers, err := c.cli.ContainerList(ctx, container.ListOptions{})
    if err != nil {
        return nil, err
    }

    results := make(map[string]model.ContainerInfo)
    for _, cntr := range containers {
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

        results[cntr.ID] = model.ContainerInfo{
            ID:   cntr.ID,
            Name: name,
            IPs:  ips,
        }
    }

    return results, nil
}