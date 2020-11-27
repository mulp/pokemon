
The idea behind the project is to show the MVVM UI architectural pattern.

I have test driven the core module of the app: the two loaders and the HTTP client. Unfortunately, due to lack of time
I didn't do the same for the rest of the app. There's room for Snapshot test by using Nimble or even a custom solution and
end-to-end test, to proof that the communication with the server works.

I've used one external library using Cocoa pods: RxSwift, to create the binding between the view and the viewModel. There are
different ways to create such a binding, by using a completion closure or a delegate pattern. These two methods don't require
any external library which in same case may be useful.

I also tried to apply SOLID principles to have a better separation of responsibilities and avoid leaking implementation
details there where they are not needed.

Side notes:

For the sake of the test I have choosen to use the default API to request the list of pokemon, which returns 20
items if no other parameter is specified. Based on the API, would be possible to realise also pagination.
