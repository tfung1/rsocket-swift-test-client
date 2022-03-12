# rsocket-swift-test-client

RSocket swift client used for testing key features and functionalities

## Getting Started

### Build

```
swift build
```

### Startup Local Server

Local RSocket server that echos back request/respone metadata and data

1. clone https://github.com/tfung1/rsocket-test-server
2. start server
    ```
    yarn start
    ```

### Testing

```
swift test
```

## Test cases

1. RequestResponse metadata and data sent are the same
