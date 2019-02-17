import tink.streams.Stream;
import tink.CoreApi;
import tink.http.containers.*;
import tink.http.Response;
import tink.http.middleware.WebSocket;
import tink.web.routing.*;
import tink.websocket.*;

class Main {
	public static function main() {
		var container = new NodeContainer(8080);
		var router = new Router<Root>(new Root());

		var handler:tink.http.Handler = (req) -> {
			return router.route(Context.ofRequest(req)).recover(OutgoingResponse.reportError);
		};

		var signal = tink.core.Signal.trigger();
		handler = handler.applyMiddleware(new tink.http.middleware.WebSocket(req -> {
			req.stream.forEach(x -> {
				trace("GOOD2");
				signal.trigger(Data(RawMessage.Text("Hello")));
				Resume;
			}).handle(e -> {
				trace(e);
			});

			return new SignalStream(signal.asSignal());
		}));

		container.run(handler).handle(o -> switch o {
			case Running(r):
				trace('running');

			case Shutdown:
				trace('shutdown');

			case Failed(e):
				trace('failed');
		});
	}
}

class Root {
	public function new() {}

	@:get('/')
	@:get('/$name')
	public function hello(name = 'World')
		return 'Hello, fucking $name!';
}
