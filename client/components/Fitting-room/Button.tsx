import React from 'react';
import { TouchableOpacity, Text, StyleSheet, View } from 'react-native';

// Định nghĩa type ButtonProps
interface ButtonProps {
  title: string;
  onPress: () => void;
  disabled?: boolean;
  icon?: React.ReactNode; // Thêm prop icon
  style?: object; // Thêm prop style để tùy chỉnh nếu cần
}

const Button: React.FC<ButtonProps> = ({ title, onPress, disabled = false, icon, style }) => {
  return (
    <TouchableOpacity
      style={[styles.button, disabled && styles.disabled, style]}
      onPress={onPress}
      disabled={disabled}
    >
      <View style={styles.content}>
        {icon && <View style={styles.iconContainer}>{icon}</View>}
        <Text style={styles.buttonText}>{title}</Text>
      </View>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  button: {
    backgroundColor: '#007AFF',
    paddingVertical: 12,
    paddingHorizontal: 20,
    borderRadius: 25,
    alignItems: 'center',
    justifyContent: 'center',
  },
  disabled: {
    backgroundColor: '#A9A9A9',
  },
  content: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  iconContainer: {
    marginRight: 8, // Khoảng cách giữa icon và text
  },
  buttonText: {
    fontSize: 16,
    fontWeight: '600',
    color: '#fff',
  },
});

export default Button;