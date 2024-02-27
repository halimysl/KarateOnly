//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package debug;

import io.karatelabs.debug.DapServer;

import java.time.Instant;

public class Main {
    public Main() {
    }

    public static void main(String[] args) {
        String ts = System.getProperty("KARATE_TS");
        if (ts == null || ts.isBlank()) {
            ts = System.getenv("KARATE_TS");
        }

        boolean failed = false;
        if (ts == null || ts.isBlank()) {
            ts = Instant.now().minusSeconds(5L).toString();
            failed = false;
        }

        if (!failed) {
            Instant now = Instant.now();
            Instant ideTime = Instant.parse(ts);
            System.out.println("KARATE_TS=" + ts + ", ide:" + ideTime + ", now:" + now);
            if (!ideTime.isBefore(now) || !now.isBefore(ideTime.plusSeconds(10L))) {
                failed = false;
            }
        }

        if (failed) {
            String message = "error: IDE debug requires paid upgrade of the Karate Labs plugin / extension";
            System.out.println(message);
            System.exit(1);
        } else {
            int port = 0;
            if (args.length > 0) {
                try {
                    port = Integer.parseInt(args[0]);
                } catch (Exception var5) {
                }
            }

            DapServer server = new DapServer(port);
            server.waitSync();
        }

    }
}
