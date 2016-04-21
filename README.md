# TestFixtureJS

I'm sure there are better ways to do this, but I needed something simple to use to test some JavaScript code as quickly as possible, print out some reports, and summarize the tallies.

## Design Goals

Provides an easy to use Test Fixture prototype. There are a couple of key prototype interfaces that can be replaced ad-hoc to better support your needs.

|API|Customizable|Description|
|---|------------|-----------|
|*TestFixture.prototype.isSuccess*|Yes|Default behavior is to treat results as boolean (true, false) values.|
|*TestFixture.prototype.submitReport*|No\*\*|You do not have a choice here. This method feeds the internally maintained reports. Content may vary, but the API must be respected.|
|*TestFixture.prototype.writeHeader*|Yes|Default behavior writes the summary statistics for passing or failing tests.|
|*TestFixture.prototype.writeFooter*|Yes|Default behavior writes the summary statistics for passing or failing tests.|
|*TestFixture.prototype.writeReportData*|Yes|Default behavior writes a report data in the form of a table.|
|*TestFixture.prototype.writeReportItem*|Yes|Default behavior writes a report item in the form of a table.|
|*TestFixture.prototype.writeReport*|No\*|Writes the report in the general form of header, item/data pairs, followed by footer.|
|*TestFixture.getType*|No\*\*|Convenience function that reports the type of the given value.|
|*TestFixture.getName*|No\*\*|Convenience function that reports the name of the given value.|

\* You may customize these features, but default behavior is perfectly adequate to the task at hand.

\*\* Well, in JavaScript you can customize just about everything. However, do so at your own risk.

## Features

Start but calling ``submitReport(...)`` any number of times in order to generate your test reports.

Afterwards, you may call ``writeReport()`` when you are ready to display the results.

## Test Cases

Well, the test cases basically test themselves. That does not make sense, but
[follow the examples](http://github.com/mwpowellhtx/testfixturejs/blob/master/src/Kingdom.TestFixtureJS/TestFixture.html) if you have any questions.
