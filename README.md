# EOS.IO iOS assignment

Hello Chris,

I've used the link you gave me to learn about the RPC endpoins.
All the networking methods are located in  `EOSAPI.swift`. I've used  `codable` protocol to parse JSON data and populate Swift objects. 

I created an `APIError` enum that confirms to `Error` protocol to display errors. To handle them I added an extension to `UIViewController`.

To test my networking calls I've written tests for every method by using `XCTest` native library. All tests are located in `GetEOSBlockTests.swift`

Your javascript implementation of Recardian Contract lookup was SUPER helpful.

It was a pleasure working on this little exersise. Thank you for giving me an opportunity. Go EOS! 




