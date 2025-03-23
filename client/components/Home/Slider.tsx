import React from 'react';
import { View, Text, FlatList, Image, Dimensions } from 'react-native';
import { StyleSheet } from 'react-native';
import { Colors } from 'react-native/Libraries/NewAppScreen';
import Carousel from 'react-native-snap-carousel';

const {height, width } = Dimensions.get('window');

const sliderList = [
  { id: '1', image: require('@/assets/images/outfit1.jpg') },
  { id: '2', image: require('@/assets/images/outfit2.jpg') },
  { id: '3', image: require('@/assets/images/outfit3.jpg') },
];

export default function Slider() {

    const handleEndReached = () => {
        setData((prevData) => [...prevData, ...sliderList]);
        };

    return (
        <View style={styles.slider}>
        <Text 
            style={{ fontSize: 20, padding: 20 }}>
                Recent outfits
            </Text>
        <FlatList
            data={sliderList}
            horizontal
            showsHorizontalScrollIndicator={false}
            keyExtractor={(item) => item.id}
            renderItem={({ item }) => (
            <View style={{ marginRight: 50 }}>
                <Image
                source={item.image}
                style={{ width: width * 0.6, height: 0.5 * height, borderRadius: 15 }}
                resizeMode="cover"
                />
            </View>
            )}
            onEndReached={handleEndReached} // Load more when reaching the end
            onEndReachedThreshold={0.5} // Trigger when 50% scrolled
        />
        </View>
    );
}

const styles = StyleSheet.create({
    slider: {
        top: -120,
        flex: 1, // fill up all available space
        backgroundColor: Colors.light.background,
    },
});