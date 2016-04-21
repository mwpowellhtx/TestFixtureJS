var TestFixture = function() {

    this._stats = {
        passed: 0,
        failed: 0
    };

    this._reports = [];

    var writeLines = function(lines) {
        lines.every(function(l) {
            document.writeln(l);
            return true;
        });
    }

    this.isSuccess = function(x) {
        return x;
    }

    this.submitReport = function(eval, msgs, data) {

        var evaluated = typeof eval === "function"
            ? eval()
            : eval;

        var stats = this._stats;
        var succeeded = this.isSuccess(evaluated);

        if (succeeded) {
            stats.passed++;
        } else {
            stats.failed++;
        }

        this._reports.push({
            succeeded: succeeded,
            result: evaluated,
            message: msgs(evaluated),
            data: data || {}
        });
    }

    var defaultHeaderFooterHandler = function (stats) {
        var lines = [
            "<table>",
            "  <tr>",
            "    <td>PASSED:</td>",
            "    <td>" + stats.passed + "</td>",
            "  </tr>",
            "  <tr>",
            "    <td>FAILED:</td>",
            "    <td>" + stats.failed + "</td>",
            "  </tr>",
            "</table>"
        ];
        writeLines(lines);
    }

    this.writeHeader = function() {
        defaultHeaderFooterHandler(this._stats);
    }

    this.writeFooter = function() {
        defaultHeaderFooterHandler(this._stats);
    }

    var writeReportDataHandler = function(d) {

        var keys = Object.keys(d);

        if (keys.length === 0) {
            return;
        }

        /* even better would be some sort of fluent html builder */
        var lines = [
            "<br />",
            "<table>",
            "  <tr>",
            "  <td class='test-fixture-spacer'>",
            "  </td>",
            "  <td>",
            "    <table class='test-fixture-collapsed test-fixture-bordered test-fixture-spaced'>"
        ];

        if (keys.length > 0) {
            for (var j = 0; j < keys.length; j++) {
                var k = keys[j];
                lines = lines.concat([
                    "      <tr class='test-fixture-bordered'>",
                    "        <td class='test-fixture-bordered test-fixture-padded'>" + k + "</td>",
                    "        <td class='test-fixture-bordered test-fixture-padded'>" + d[k] + "</td>",
                    "      </tr>"
                ]);
            }
        }

        lines = lines.concat([
            "    </table>",
            "  </td>",
            "  </tr>",
            "</table>"
        ]);

        writeLines(lines);
    }

    this.writeReportData = function(d) {
        writeReportDataHandler(d);
    }

    var defaultWriteReportItemHandler = function(r) {
        var succeededText = r.succeeded ? "PASSED" : "FAILED";
        var resultText = " (" + r.result + ")";
        var messageText = ": " + r.message;
        writeLines([
            "<br />",
            succeededText + resultText + messageText
        ]);
    }

    this.writeReportItem = function(r) {
        defaultWriteReportItemHandler(r);
    }

    this.writeReport = function() {

        this.writeHeader();

        var reports = this._reports;

        for (var i = 0; i < reports.length; i++) {
            var item = reports[i];
            this.writeReportItem(item);
            this.writeReportData(item.data || []);
        }

        this.writeFooter();
    }
}

if (TestFixture.getType === undefined) {
    var getType = function(x) {
        /* special cases */
        if (x === null) {
            return "[object Null]";
        } else if (x === undefined) {
            return "[object Undefined]";
        }
        return Object.prototype.toString.call(x);
    }
}

if (TestFixture.getName === undefined) {
    var getName = function(x) {
        if (x === undefined) {
            return "(undefined)";
        } else if (x === null) {
            return "(null)";
        }
        return x.name;
    }
}
