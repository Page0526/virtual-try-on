import React from 'react';
import { View, Text, ImageBackground, TouchableOpacity, StyleSheet, Platform, StatusBar } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

const FashionAppScreen: React.FC = () => {
  const insets = useSafeAreaInsets();

  return (
    <View style={styles.container}>
      <StatusBar barStyle="light-content" />
      <ImageBackground
        source={require('@/assets/images/background.jpg')}
        style={styles.backgroundImage}
      >
        <View style={[styles.contentContainer, { paddingTop: insets.top }]}>
          <View style={styles.headerContainer}>
            <Text style={styles.headerText}>WHAT TO WEAR</Text>
          </View>
          
          <View style={styles.taglineContainer}>
            <Text style={styles.taglineText}>NOW SO MUCH</Text>
            <Text style={styles.taglineText}>EASIER 😍</Text>
          </View>
          
          <View style={styles.buttonContainer}>
            <TouchableOpacity style={styles.button}>
              <Text style={styles.buttonText}>Get started</Text>
            </TouchableOpacity>
          </View>
          
          
        </View>
      </ImageBackground>
    </View>
  );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#fff',
    },
    backgroundImage: {
        flex: 1,
        width: '100%',
        height: '60%',
    },
    contentContainer: {
        flex: 1,
        paddingHorizontal: '5%',
        justifyContent: 'flex-end',
        paddingBottom: '10%',
    },
    headerContainer: {
        position: 'absolute',
        top: '58%',
        left: '5%',
    },
    headerText: {
        color: '#fff',
        fontSize: 48,
        fontWeight: '600',
    },
    taglineContainer: {
        marginBottom: '30%',
    },
    taglineText: {
        color: '#000',
        fontSize: 48,
        fontWeight: 'bold',
        lineHeight: 55,
    },
    buttonContainer: {
        marginBottom: '6%',
    },
    button: {
        backgroundColor: '#f05b6e',
        paddingVertical: 15,
        borderRadius: 8,
        alignItems: 'center',
    },
    buttonText: {
        color: '#fff',
        fontSize: 18,
        fontWeight: '600',
    },
});

export default FashionAppScreen;
