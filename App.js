import React, { useState } from 'react';
import { StyleSheet, Text, TextInput, View } from 'react-native';

import SharedGroupPreferences from 'react-native-shared-group-preferences';

const appGroupIdentifier = 'group.jad.RNWidgets';

export default function App() {
  const [inputText, setInputText] = useState('');
  const widgetData = {
    displayText: inputText,
  };

  const handleSubmit = async () => {
    try {
      await SharedGroupPreferences.setItem(
        'savedData', // this is a key to pull from later in Swift
        widgetData,
        appGroupIdentifier
      );
    } catch (error) {
      console.log({ error });
    }
  };

  return (
    <View style={styles.container}>
      <Text>Enter text to display on widget:</Text>
      <TextInput
        // style={styles.input}
        onChangeText={(text) => setInputText(text)}
        value={inputText}
        returnKeyType="send"
        onEndEditing={handleSubmit}
        placeholder="Enter text"
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
