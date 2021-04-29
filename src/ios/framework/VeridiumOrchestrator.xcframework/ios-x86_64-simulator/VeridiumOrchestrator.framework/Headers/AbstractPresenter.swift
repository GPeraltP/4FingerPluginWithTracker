import UIKit

open class AbstractPresenter<GenericView: BaseViewProtocol>: NSObject {
  
    public var genericView: GenericView!
  
    override public init() { super.init()  }
    
    public func setView (view: GenericView) {
        self.genericView = view
    }
}
