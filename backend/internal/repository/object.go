package repository

type Object interface {
	Get(key string) (any, error)
	Post(key string, value any) error
	Put(key string, value any) error
	Delete(key string) error
}
