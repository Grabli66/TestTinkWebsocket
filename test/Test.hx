import js.html.WebSocket;

class Test {
    public static function main() {
        var ws = new WebSocket("ws://localhost:8080");
        ws.onopen = () -> {
            trace("OPEN");
            ws.send("HELLO");
        };        

        ws.onmessage = (e) -> {
            trace(e);
        };

        ws.onerror = (e) -> {
            trace(e);
        };
    }
}