package docker

import (
    "context"
    "strings"
    "github.com/docker/docker/api/types"
    dockerClient "github.com/docker/docker/client"
	"pinger/domain"
)

type Client struct {
    cli *dockerClient.Client
}

// New создает клиента Docker.
func New() (*Client, error) {
    cli, err := dockerClient.NewClientWithOpts(dockerClient.FromEnv)
    return &Client{cli: cli}, err
}

// GetContainers возвращает информацию о контейнерах.
func (c *Client) GetContainers(ctx context.Context) (map[string]domain.ContainerInfo, error) {
    containers, err := c.cli.ContainerList(ctx, types.ContainerListOptions{})
    if err != nil {
        return nil, err
    }

    results := make(map[string]domain.ContainerInfo)
    for _, container := range containers {
        var name string
        if len(container.Names) > 0 {
            name = strings.TrimPrefix(container.Names[0], "/")
        } else {
            name = container.ID[:12]
        }

        var ips []string
        for _, netSettings := range container.NetworkSettings.Networks {
            if netSettings.IPAddress != "" {
                ips = append(ips, netSettings.IPAddress)
            }
        }

        results[container.ID] = domain.ContainerInfo{
            ID:   container.ID,
            Name: name,
            IPs:  ips,
        }
    }

    return results, nil
}