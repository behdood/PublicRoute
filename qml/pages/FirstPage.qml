/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: firstPage

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: "Show Page 2"
                onClicked: pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: firstPage.width
            spacing: Theme.paddingLarge

        }
    }

    Text {

        id: header1
        x: 170
        y: 50
        text: "Public Route"
        font.bold: true
        font.pointSize: 30
        color: "#09CBFF"

    }

    Label {
        x: 25
        y: 120
        text: "From :"
    }

    TextField {
        id: source1
        x: 100
        y: 110
        width: 400
//        placeholderText: "Source" // "Skinnarilankatu 34" //
//        text: "skinnarilnkatu34"
        text: "punkkerikatu5"
    }

    Label {
        x: 25
        y: 170
        text: "To :"
    }

    TextField {
        id: destination1
        x: 100
        y: 160
        width: 400
//        placeholderText: "Destination"
        text: "valtakatu8"
    }

    Button {
        id: time1
        text: "20:00"
        width:  180
        height: 40
        x: 310
        y: 270

        function parseTime(timeText){
            var result = timeText.split(":")
            return result
        }
        function getValue(){
            var data = time1.text.split(":");
            var result = "" + data[0] + data[1]
            return result
        }
        onClicked: {
            var dialog = pageStack.push("Sailfish.Silica.TimePickerDialog", {
                                            hour: parseTime(time1.text)[0],
                                            minute: parseTime(time1.text)[1],
                                            hourMode: DateTime.TwentyFourHours
                                        })

            dialog.accepted.connect(function() {

                time1.text = "" + dialog.timeText
            })
        }
    }



    Button {
        id: date1
        x: 310
        y: 340
        width:  180
        height: 40
        text: "03-10-2014"

        function parseDate(dateText){
            var result = dateText.split("-")
            return result
        }
        function getValue(){
            var data = date1.text.split("-");
            var result = "" + data[2] + data[0] + data[1]
            return result
        }

        onClicked: {
//            if (date1.text == "date")


            var dialog = pageStack.push("Sailfish.Silica.DatePickerDialog", {
//                                            month : 12, year: 2013, day : 11,
//                                            month : parseDate(date1.text)[0], year: parseDate(date1.text)[2], day : parseDate(date1.text)[1],
//                                            date: new Date(text)
                                            date: new Date(parseDate(date1.text)[2], parseDate(date1.text)[0]-1, parseDate(date1.text)[1], 12, 0, 0)
                                        })
            dialog.accepted.connect(function() {

//                date1.text = "" +  dialog.month

                var m = dialog.month
                var d = dialog.day
                if (m<10){
                    m = "0"+m
                }
                if (d<10){
                    d = "0"+d
                }
                date1.text = m + "-" + d + "-" + dialog.year


            })
        }

//        Component {
//            id: pickerComponent
//            DatePickerDialog {}
//        }
    }

    ComboBox {
        id: combo1
        x: 20
        y: 250
        width: 320
        scale: 0.8
        label: ""

        function getValue() {

            return combo1.currentIndex + 1;
        }

        menu: ContextMenu {
            MenuItem { text: "Deparature" }
            MenuItem { text: "Arrival" }

        }
    }

    ComboBox {
        id: combo2
        x: 20
        y: 440
        width: 300
        label: "Optimiztaion :"
        scale: 0.8


        function getValue() {
            return combo2.currentIndex + 2;
        }

        menu: ContextMenu {
            MenuItem { text: "Fastest" }
            MenuItem { text: "Minimize Changes" }
            MenuItem { text: "Minimize Walks" }
        }
    }

    Button {
        id: search1
        x: 310
        y: 520
        width: 180
        text: "Search"
        function getResults(){
            var results = new Array(6);
            results[0] = source1.text;
            results[1] = destination1.text;
            results[2] = time1.getValue();
            results[3] = date1.getValue();
            results[4] = combo1.getValue();
            results[5] = combo2.getValue();
            return results;
        }
        onClicked: {

            console.log(search1.getResults())
            var results = getResults();
            if (results[0] === "") {

            }

            pageStack.push(Qt.resolvedUrl("MapPage.qml"), {"source" : results[0] , "destination" : results[1],
                               "time" : results[2], "date" : results[3], "arr_dep" : results[4], "optimizeMethod" : results[5]})

        }
    }
}
