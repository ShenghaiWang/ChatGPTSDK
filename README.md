# ChatGPTSDK

A description of this package.

## Usage:

### 1 setup key

    ChatGPTSDK.setAPIKey("...") 
    
### 2 call chat gpt (Take `Completion` as an example)

    let request = CompletionEndpoint.Request(prompt: "This is a test")
    let endpoit = CompletionEndpoint(request: request)

#### via publisher

    endpoint
        .sink(receiveCompletion: { error in
            // error handling
        }, receiveValue: {[weak self] value in
            self?.result = value.choices.first?.text ?? ""
        })

#### vai async/await

    do {
        let value = try await endpoint.run()
        result = value?.choices.first?.text ?? ""
    } catch {
        // error handling
    }

#### via completion

    endpoint.run { value, error in
        // error handling
        self?.result = value?.choices.first?.text ?? ""
    }
