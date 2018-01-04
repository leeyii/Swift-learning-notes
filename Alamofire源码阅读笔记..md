# Alamofire源码阅读笔记.

Alamofire是swift中常用的网络请求框架.
本篇源码基于

## request

通常在使用Alamofire做网络请求时,调用方式是

	Alamofire.request("www.example.com").responseJSON { (respones) in
	            
	}

接下来我们一步一步来分析.

首先,Alamofire调用`request`方法, 在`Alamofire.swift`文件中可以看到`data request`,有两个和request相关的方法.

	// MARK: - Data Request
	
	/// Creates a `DataRequest` using the default `SessionManager` to retrieve the contents of the specified `url`,
	/// `method`, `parameters`, `encoding` and `headers`.
	///
	/// - parameter url:        The URL.
	/// - parameter method:     The HTTP method. `.get` by default.
	/// - parameter parameters: The parameters. `nil` by default.
	/// - parameter encoding:   The parameter encoding. `URLEncoding.default` by default.
	/// - parameter headers:    The HTTP headers. `nil` by default.
	///
	/// - returns: The created `DataRequest`.
	@discardableResult
	public func request(
	    _ url: URLConvertible,
	    method: HTTPMethod = .get,
	    parameters: Parameters? = nil,
	    encoding: ParameterEncoding = URLEncoding.default,
	    headers: HTTPHeaders? = nil)
	    -> DataRequest
	{
	    return SessionManager.default.request(
	        url,
	        method: method,
	        parameters: parameters,
	        encoding: encoding,
	        headers: headers
	    )
	}

上面就是第一个实现:可以看到除了第一个参数之后没有给默认值之外,其他的几个参数都有默认值.因此上面给出的例子中调用的实际就是这个方法,因为后面的几个参数都有默认值,所以可以省略这些参数.

接下来我们分别来分析这个方法的的每个参数的作用:

 **参数1** `url: URLConvertible` 类型为`URLConvertible`的参数.在`Alamofire.swift`可以看到`URLConvertible`实际上是一个协议.

	public protocol URLConvertible {
	    func asURL() throws -> URL
	}

所有遵守这个协议的类,都可以转换成`URL`.

在`Alamofire.swift`中分别为`String`,`URL`,`URLComponents`这三个类型遵守了这个协议,具体每个类型中协议方法实现非常简单,可以自己去看.

同时我们也可以根据实际需求自己实现`URLConvertible `协议,也是可以的,在`Alamofire`框架中`AdvancedUsage`文件中,作者也为我们介绍了相关的用法.

**参数2**  `method: HTTPMethod = .get` 请求类型,默认为get请求.

**参数3** `parameters: Parameters? = nil` 请求的参数,默认为空.

**参数4**: `encoding: ParameterEncoding = URLEncoding.default` url编码方式,默认是`URLEncoding.default`根据HTTPMethod决定参数是拼接在url中还是request Body中. `ParameterEncoding`是一个协议.

	/// A type used to define how a set of parameters are applied to a `URLRequest`.
	public protocol ParameterEncoding {
	    /// Creates a URL request by encoding parameters and applying them onto an existing request.
	    ///
	    /// - parameter urlRequest: The request to have parameters applied.
	    /// - parameter parameters: The parameters to apply.
	    ///
	    /// - throws: An `AFError.parameterEncodingFailed` error if encoding fails.
	    ///
	    /// - returns: The encoded request.
	    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest
	}

上面是`ParameterEncoding`具体内容,此协议定义如何将参数应用在`URLRequest`中.`alamofire `为我们实现了三种编码方式,分别是`URLEncoding`,`JSONEncoding`,`PropertyListEncoding`具体的实现可以去在`ParameterEncoding.swift`文件中查看.

**参数5** `headers: HTTPHeaders? = nil` 请求头.默认为空

---
	
	/// Creates a `DataRequest` using the default `SessionManager` to retrieve the contents of a URL based on the
	/// specified `urlRequest`.
	///
	/// - parameter urlRequest: The URL request
	///
	/// - returns: The created `DataRequest`.
	@discardableResult
	public func request(_ urlRequest: URLRequestConvertible) -> DataRequest {
	    return SessionManager.default.request(urlRequest)
	}

这是第二个request方法,只有一个`URLRequestConvertible `类型的参数.
	
	public protocol URLRequestConvertible {
	    /// Returns a URL request or throws if an `Error` was encountered.
	    ///
	    /// - throws: An `Error` if the underlying `URLRequest` is `nil`.
	    ///
	    /// - returns: A URL request.
	    func asURLRequest() throws -> URLRequest
	}

以上就是`URLRequestConvertible `协议的内容.准守此协议的都可以转换为`URLRequest`. `alamofire`默认为`URLRequest `准守了此协议.

以上是request方法参数的介绍,接下来是两个方法的实现,实现都非常的简单.调用`SessionManager.default`相应的request方法.接下来我们来看一下`SessionManager`这个类.

### SessionManager

>  Responsible for creating and managing `Request` objects, as well as their underlying `NSURLSession`.

这个类的作用是负责创建和管理`request`和`NSURLSession`


`SessionManager.default`是这个类的类属性.

	open static let `default`: SessionManager = {
	        let configuration = URLSessionConfiguration.default
	        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
	
	        return SessionManager(configuration: configuration)
	}()

创建一个默认的`URLSessionConfiguration`并调用`SessionManager(configuration: configuration)`方法

这个方法实际上调用的这个类的`designated initializer`

    public init(
        configuration: URLSessionConfiguration = URLSessionConfiguration.default,
        delegate: SessionDelegate = SessionDelegate(),
        serverTrustPolicyManager: ServerTrustPolicyManager? = nil)
    {
        self.delegate = delegate
        self.session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
        
        commonInit(serverTrustPolicyManager: serverTrustPolicyManager)
    }



