# Golang Project Development Setup

This is an example configuration for a Go project.

## Prerequisites

Make sure you have installed the dotfiles:
```bash
cd ~/coder_dotfiles
./install.sh
./install-dev-tools.sh
```

## Quick Start

1. Copy `.tool-versions` to your project root
2. Install required version:
   ```bash
   asdf install
   ```

3. Create a new Go project:
   ```bash
   mkdir my-go-app
   cd my-go-app
   go mod init github.com/yourusername/my-go-app
   ```

4. Copy `.tool-versions` to your project
5. Create main.go:
   ```go
   package main

   import "fmt"

   func main() {
       fmt.Println("Hello, World!")
   }
   ```

6. Run your application:
   ```bash
   go run main.go
   ```

## Project Structure

### Simple CLI App
```
my-go-app/
├── main.go
├── go.mod
├── go.sum
├── .tool-versions
└── README.md
```

### Web API
```
my-go-app/
├── cmd/
│   └── server/
│       └── main.go
├── internal/
│   ├── handlers/
│   ├── models/
│   └── services/
├── pkg/
│   └── utils/
├── go.mod
├── go.sum
├── .tool-versions
└── README.md
```

## Development Workflow

1. Start tmux session:
   ```bash
   tmux new -s golang
   ```

2. Split panes (prefix + |):
   - Pane 1: Development/watching (`air` for hot reload)
   - Pane 2: Testing (`go test -v ./...`)
   - Pane 3: Git/commands

3. Save tmux session (prefix + Ctrl+s)

## Development Tools

The dotfiles install these Go tools:

- **gopls** - Language server for Go
- **delve** - Debugger for Go
- **goimports** - Formats code and manages imports
- **golangci-lint** - Linter aggregator
- **air** - Live reload for Go apps

## Common Commands

```bash
# Initialize a new module
go mod init github.com/username/project

# Add dependencies
go get github.com/gin-gonic/gin

# Update dependencies
go get -u ./...

# Tidy dependencies
go mod tidy

# Run application
go run main.go
go run cmd/server/main.go

# Build application
go build -o bin/app
go build -o bin/server cmd/server/main.go

# Run tests
go test ./...
go test -v ./...
go test -cover ./...

# Run specific test
go test -run TestFunctionName

# Generate test coverage
go test -coverprofile=coverage.out ./...
go tool cover -html=coverage.out

# Format code
go fmt ./...
gofmt -w .

# Manage imports
goimports -w .

# Run linter
golangci-lint run

# Install dependencies
go mod download

# Verify dependencies
go mod verify

# Show module dependency graph
go mod graph
```

## Hot Reload with Air

Install Air (already done by dotfiles):
```bash
go install github.com/cosmtrek/air@latest
```

Create `.air.toml`:
```toml
root = "."
testdata_dir = "testdata"
tmp_dir = "tmp"

[build]
  args_bin = []
  bin = "./tmp/main"
  cmd = "go build -o ./tmp/main ."
  delay = 1000
  exclude_dir = ["assets", "tmp", "vendor", "testdata"]
  exclude_file = []
  exclude_regex = ["_test.go"]
  exclude_unchanged = false
  follow_symlink = false
  full_bin = ""
  include_dir = []
  include_ext = ["go", "tpl", "tmpl", "html"]
  kill_delay = "0s"
  log = "build-errors.log"
  poll = false
  poll_interval = 0
  rerun = false
  rerun_delay = 500
  send_interrupt = false
  stop_on_error = false

[color]
  app = ""
  build = "yellow"
  main = "magenta"
  runner = "green"
  watcher = "cyan"

[log]
  time = false

[misc]
  clean_on_exit = false
```

Run with:
```bash
air
```

## Web Framework Example (Gin)

Install Gin:
```bash
go get -u github.com/gin-gonic/gin
```

Example server:
```go
package main

import (
    "github.com/gin-gonic/gin"
    "net/http"
)

func main() {
    r := gin.Default()
    
    r.GET("/", func(c *gin.Context) {
        c.JSON(http.StatusOK, gin.H{
            "message": "Hello, World!",
        })
    })
    
    r.Run(":8080")
}
```

## Testing

Example test file (`main_test.go`):
```go
package main

import "testing"

func TestExample(t *testing.T) {
    expected := "Hello, World!"
    actual := "Hello, World!"
    
    if expected != actual {
        t.Errorf("Expected %s, got %s", expected, actual)
    }
}
```

## Debugging with Delve

Start debugger:
```bash
dlv debug
```

Common dlv commands:
```
break main.main     # Set breakpoint
continue            # Continue execution
next                # Step over
step                # Step into
print var           # Print variable
quit                # Exit debugger
```

## Code Quality

### Linting with golangci-lint

Run all linters:
```bash
golangci-lint run
```

Configuration (`.golangci.yml`):
```yaml
linters:
  enable:
    - gofmt
    - golint
    - govet
    - errcheck
    - staticcheck
    - unused
    - gosimple
    - structcheck
    - varcheck
    - ineffassign
    - deadcode
```

## Environment Variables

Use godotenv for local development:
```bash
go get github.com/joho/godotenv
```

```go
import "github.com/joho/godotenv"

func init() {
    godotenv.Load()
}
```

## Popular Go Packages

### Web Frameworks
- Gin: `go get -u github.com/gin-gonic/gin`
- Echo: `go get -u github.com/labstack/echo/v4`
- Fiber: `go get -u github.com/gofiber/fiber/v2`

### Database
- GORM: `go get -u gorm.io/gorm`
- sqlx: `go get -u github.com/jmoiron/sqlx`

### Testing
- Testify: `go get -u github.com/stretchr/testify`
- Gomega: `go get -u github.com/onsi/gomega`

### CLI
- Cobra: `go get -u github.com/spf13/cobra`
- Viper: `go get -u github.com/spf13/viper`

## Deployment

### Build for Production
```bash
# Build optimized binary
go build -ldflags="-s -w" -o bin/app

# Cross-compile for Linux
GOOS=linux GOARCH=amd64 go build -o bin/app-linux

# Cross-compile for Windows
GOOS=windows GOARCH=amd64 go build -o bin/app.exe
```

### Docker

Example `Dockerfile`:
```dockerfile
FROM golang:1.21-alpine AS builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -ldflags="-s -w" -o main .

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/main .

EXPOSE 8080
CMD ["./main"]
```

## Performance Profiling

CPU profiling:
```bash
go test -cpuprofile=cpu.prof
go tool pprof cpu.prof
```

Memory profiling:
```bash
go test -memprofile=mem.prof
go tool pprof mem.prof
```

## Common Issues

### Module not found

Run:
```bash
go mod tidy
go mod download
```

### Import conflicts

Use Go workspaces:
```bash
go work init
go work use .
```
