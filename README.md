# ChatGPTSDK

ChatGPT SDK: Includes all the endpoints provided by OpenAI.

## Install

    .package(url: "https://github.com/ShenghaiWang/ChatGPTSDK.git", from: "1.0.0")

## Usage

### 1 setup key

    ChatGPTSDK.setAPIKey("...") 
    
### 2 call chat gpt (Take `Completion` as an example)

    let request = CompletionEndpoint.Request(prompt: "This is a test")
    let endpoit = CompletionEndpoint(request: request)

#### via publisher

    endpoint
        .sink(receiveCompletion: { error in
            // error handling
        }, receiveValue: { [weak self] value in
            self?.result = value.choices.first?.text ?? ""
        })

    Note: this is the only api that supports parameter `stream=true`

#### via async/await

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
