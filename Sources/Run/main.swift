import App
import Vapor

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env, env.isRelease ? .shared(MultiThreadedEventLoopGroup(numberOfThreads: 1)) : .createNew)
defer { app.shutdown() }
try configure(app)
try app.run()
