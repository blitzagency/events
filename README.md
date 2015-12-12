# Events

Represents an attempt to bring backbone style events to Swift.

Delegates are fine, and they are probably more performanent, but
it is so much faster to just keep coding than to:

1. Stop coding
2. Create a new protocol
3. Create an implementation of that protocol
4. Add the delegate to the object that needs it
5. Alter your code to use the delegate


Events let you just keep going. Need to communicate between N
Child ViewControllers to their parent ViewController, no problem with
events:

```swift
import Events

class ParentViewController: EventViewController {

    func viewDidLoad(){
        super.viewDidLoad()
        let blue = BlueViewController(nibName: "Blue", bundle: nil)
        let red = RedViewController(nibName: "Red", bundle: nil)

        // see how we define these handlers below, it's important!
        self.listenTo(blue, "some:blue:event", callback: onBlueEvent)
        self.listenTo(red, "some:red:event",  callback: onRedEvent)

        addChildViewController(blue)
        addChildViewController(red)

        view.addSubView(blue.view)
        view.addSubView(red.view)
    }

    // Note that it casts the values back to what you expect
    // vs NSNotification which requires manual casting at runtime
    // also note the specific construction of this handler. lazy var
    // with [unowned self] capture list
    //
    // see: https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html#//apple_ref/doc/uid/TP40014097-CH20-ID57
    // Resolving Stong Reference Cycles for Closures why we do this.
    //
    // TL;DR: using an instance method like: func onBlueEvent(...)
    // strongly captures self.
    lazy var onBlueEvent: (BlueViewController, Int) -> () = { [unowned self]
        (sender, data) in
        print("\(sender): \(data)")
    }

    // Note that it casts the values back to what you expect
    // vs NSNotification which requires manual casting at runtime
    lazy var onRedEvent: (BlueViewController, Bool) -> () = { [unowned self]
        (sender, data) in
        print("\(sender): \(data)")
    }

    func viewDidDisappear(animated: Bool){
        super.viewDidDisappear(animated)

        // free the listeners
        self.stopListening()
    }
}

class BlueViewController: EventViewController{
    func viewDidLoad(){
        super.viewDidLoad()
        doSomething()
    }

    func doSomething(){
        self.trigger("some:blue:event", 36)
    }
}

class RedViewController : EventViewController{
    func viewDidLoad(){
        super.viewDidLoad()
        doSomething()
    }

    func doSomething(){
        self.trigger("some:red:event", true)
    }
}
```
