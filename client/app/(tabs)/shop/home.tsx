import Header from '@/app/components/Home/Header';
import Slider from '@/app/components/Home/Slider';
import { Colors } from '@/constants/Colors';
import {Text, View} from 'react-native';
import { StyleSheet } from 'react-native';

export default function home() {
    return (
        <View style={styles.container}>
            {/* Header */}
            <Header/>
            {/* Slider */}
            <Slider/>
            {/* Most ordered */}
        </View>
    )
}

const styles = StyleSheet.create({
    container: {
        flex: 1, // fill up all available space
        backgroundColor: Colors.light.background,
    },
});
