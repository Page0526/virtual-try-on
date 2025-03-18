import { Image, StyleSheet, Platform, View, Text } from "react-native";

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: "center",
        alignItems: "center",
        backgroundColor: "#F5FCFF",
    },
    text: {
        fontSize: 20,
        textAlign: "center",
        margin: 10,
    },
    logo: {
        width: 66,
        height: 58,
        marginTop: Platform.OS === "android" ? 20 : 0,
    },
    });

export default function HomeScreen() {
  return (
    <View style={styles.container}>
      <Text style={styles.text}>Hello, world!</Text>
      <Image
        source={{
          uri: "https://reactnative.dev/img/tiny_logo.png",
        }}
        style={styles.logo}
      />
    </View>
  );
}

