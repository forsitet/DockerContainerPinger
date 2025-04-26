package docker

import (
	"context"
	"log"
	"strings"
	"time"

	"pinger/domain"

	"github.com/docker/docker/api/types/container"
	dockerClient "github.com/docker/docker/client"
)

type Client struct {
	cli *dockerClient.Client
}

func New() (*Client, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	cli, err := dockerClient.NewClientWithOpts(
		dockerClient.FromEnv,
		dockerClient.WithVersion("1.47"),
	)
	if err != nil {
		return nil, err
	}

	_, err = cli.Ping(ctx)
	if err != nil {
		return nil, err
	}

	log.Println("Successfully connected to Docker Engine with API v1.47")

	return &Client{cli: cli}, nil
}

func (c *Client) GetContainerInfos() (map[string]domain.ContainerInfo, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	containers, err := c.cli.ContainerList(ctx, container.ListOptions{})
	if err != nil {
		return nil, err
	}

	results := make(map[string]domain.ContainerInfo)
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

		results[cntr.ID] = domain.ContainerInfo{
			ID:   cntr.ID,
			Name: name,
			IPs:  ips,
		}
	}

	return results, nil
}