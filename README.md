# ISBNBuilder

Swift Package that creates a `ISBN` based on input value if it's valid.

## Install

```
dependencies: [
    .package(url: "https://github.com/PeerBookClub/ISBNBuilder.git", exact: "1.0.0")
]
```

## Usage

Create a `ISBN` using the builder and switch on its result:

```swift
let result = ISBNBuilder.buildISBN(rawValue: input)

// return Result<ISBN, ISBNError>

```

## License

ISBNBuilder is available under the MIT license. See the LICENSE file for more info.
