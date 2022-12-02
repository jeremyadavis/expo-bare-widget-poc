//
//  Countdown.swift
//  Countdown
//
//  Created by Jeremy Davis on 12/1/22.
//

import WidgetKit
import SwiftUI
import Intents

struct WidgetData: Decodable {
   var displayText: String
}

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), displayText: "Widget preview")
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, displayText: "Widget preview")
        completion(entry)
    }
  

  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
      let entryDate = Date()
      
      let userDefaults = UserDefaults.init(suiteName: "group.jad.RNWidgets")
      if userDefaults != nil {
          if let savedData = userDefaults!.value(forKey: "savedData") as? String {
          let decoder = JSONDecoder()
          let data = savedData.data(using: .utf8)
          
          if let parsedData = try? decoder.decode(WidgetData.self, from: data!) {
              let nextRefresh = Calendar.current.date(byAdding: .minute, value: 5, to: entryDate)!
              let entry = SimpleEntry(date: nextRefresh, configuration: configuration, displayText: parsedData.displayText)
              let timeline = Timeline(entries: [entry], policy: .atEnd)
              
              completion(timeline)
          } else {
              print("Could not parse data")
          }
          
          } else {
              let nextRefresh = Calendar.current.date(byAdding: .minute, value: 5, to: entryDate)!
              let entry = SimpleEntry(date: nextRefresh, configuration: configuration, displayText: "No data set")
              let timeline = Timeline(entries: [entry], policy: .atEnd)
              
              completion(timeline)
          }
      }
  }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let displayText: String
}

struct CountdownEntryView : View {
    var entry: Provider.Entry

    var body: some View {
      LinearGradient(gradient: Gradient(colors: [.red, .orange]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.vertical)
            .overlay(
              VStack {
                Text(entry.displayText)
                  .bold()
                  .foregroundColor(.white)
              }.padding(20)
            )
    }
}

struct Countdown: Widget {
    let kind: String = "Countdown"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            CountdownEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct Countdown_Previews: PreviewProvider {
    static var previews: some View {
        CountdownEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), displayText: "Widget preview"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
