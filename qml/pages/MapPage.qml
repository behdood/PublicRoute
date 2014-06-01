import QtQuick 2.0
import Sailfish.Silica 1.0
import QtWebKit 3.0
import QtWebKit.experimental 1.0
import QtQuick.XmlListModel 2.0

Page {
    id: mapPage

    property string source
    property string destination
    property string time
    property string date
    property string arr_dep
    property string optimizeMethod


    property string queryResults;
    property string endPoints;
    property string busStops;

    XmlListModel {
        id: routeEndPoints
        source: makeUrl()
        query: "/MTRXML/ROUTE"

        XmlRole {
            name: "srcX"
            query: "POINT[1]/@x/string()"
        }
        XmlRole {
            name: "srcY"
            query: "POINT[1]/@y/string()"
        }
        XmlRole {
            name: "srcDate"
            query: "POINT[1]/DEPARTURE/@date/string()"
        }
        XmlRole {
            name: "srcTime"
            query: "POINT[1]/DEPARTURE/@time/string()"
        }

        XmlRole {
            name: "dstX"
            query: "POINT[2]/@x/string()"
        }
        XmlRole {
            name: "dstY"
            query: "POINT[2]/@y/string()"
        }
        XmlRole {
            name: "dstDate"
            query: "POINT[2]/DEPARTURE/@date/string()"
        }
        XmlRole {
            name: "dstTime"
            query: "POINT[2]/DEPARTURE/@time/string()"
        }
        XmlRole {
            name: "busLine"
            query: "LINE/@code/string()"
        }

        onStatusChanged: {
            if (status === XmlListModel.Ready) {
                console.log("endpoints : " + source)
                endPoints = getEndPoints();
                console.log("----------- Endpoints ARE READY ---------------")
            }
        }
    }

    XmlListModel {
        id: busStations
        source: makeUrl()
        query: "/MTRXML/ROUTE/LINE/STOP"

        XmlRole {
            name: "xValue"
            query: "@x/string()"
        }
        XmlRole {
            name: "yValue"
            query: "@y/string()"
        }
        XmlRole {
            name: "depTime"
            query: "DEPARTURE/@time/string()"
        }
        XmlRole {
            name: "stopName"
            query: "NAME[1]/@val/string()"
        }
        onStatusChanged: {
            if (status === XmlListModel.Ready) {
                console.log("stops:" + source)
                busStops = getStops();
                console.log("----------- BUS STOPS ARE READY ---------------")
            }
        }
    }

    function makeUrl() {
        if (mapPage.source === "") {
            mapPage.source = "skinnarilankatu34"
        }
        if (mapPage.destination === "") {
            mapPage.destination = "valtakatu8"
        }

        return "http://api.matka.fi/public-lvm/fi/api/"+"?from="+ mapPage.source +",lappeenranta&to=" +
                mapPage.destination + ",lappeenranta&time=" + time + "&date=" + date + "&timemode=" + arr_dep +
                "&optimize=" + optimizeMethod + "&show=1&user=lutopendatacourse&pass=Doo7ieci";
    }

    function getEndPoints() {
        var results
        results = routeEndPoints.get(0).srcX + ";" + routeEndPoints.get(0).srcY + ";" +
                  mapPage.source + ";" + routeEndPoints.get(0).srcTime + ";" +
                  routeEndPoints.get(0).dstX + ";" + routeEndPoints.get(0).dstY + ";" +
                    mapPage.destination + ";" + routeEndPoints.get(0).dstTime + ";" +
                    routeEndPoints.get(0).busLine;
        return results
    }

    function getStops() {
        var results
        results = busStations.count;
        for (var ii = 0; ii < busStations.count; ii++) {
            results += ";" + busStations.get(ii).xValue + ";" + busStations.get(ii).yValue +
                    ";" + busStations.get(ii).stopName + ";" + busStations.get(ii).depTime;
         }
        return results
    }

    WebView{
        id: webView
        url: Qt.resolvedUrl("../showMap.html")
        anchors.fill: parent

        experimental.preferences.navigatorQtObjectEnabled: true
        experimental.onMessageReceived: {

            while (busStations.status !== XmlListModel.Ready || routeEndPoints.status !== XmlListModel.Ready) {}

            console.log("data to be sent: " + endPoints + ";" + busStops)
            experimental.postMessage(endPoints + ";" + busStops)
        }
    }
}
