import axios from 'axios';
import * as FileSystem from 'expo-file-system';
import Constants from 'expo-constants';
import { Platform } from 'react-native';

// Dynamic API URL configuration
const getApiUrl = () => {
  // When running in development
  if (__DEV__) {
    // For Android emulator, localhost points to the emulator itself, not your machine
    if (Platform.OS === 'android') {
      return 'http://10.0.2.2:8000'; 
    }
    // For iOS simulator
    else if (Platform.OS === 'ios') {
      return 'http://localhost:8000'; //
    }

    return Constants.expoConfig?.extra?.apiUrl || 'http://127.0.0.1:8000';
  }
  // For production, use a production URL
  return Constants.expoConfig?.extra?.apiUrl || 'https://your-production-api.com';
};

const API_URL = getApiUrl();
console.log('Using API URL:', API_URL); 

export const recommendService = {
  async getRecommendations(input: { text?: string; image?: string }) {
    try {
      if (!input.text && !input.image) {
        throw new Error('Must provide either text or image for recommendations');
      }

      const response = await axios.post(`${API_URL}/products/recommend`, input, {
        headers: {
          'Content-Type': 'application/json',
        },
      });

      return response.data;
    } catch (error: any) {
      console.error('Error in getRecommendations:', error);
      if (axios.isAxiosError(error)) {
        const status = error.response?.status;
        const errorDetail = error.response?.data?.detail || error.message;
        console.error('Axios error details:', { status, errorDetail });
        throw new Error(`Could not get recommendations: ${errorDetail} (Status: ${status})`);
      } else {
        throw new Error(`Unexpected error: ${error.message}`);
      }
    }
  },
};

export const tryOnService = {
  async processTryOn(
    garmentUri: string,
    modelUri: string,
    options: {
      garment_des?: string;
      is_checked?: boolean;
      is_checked_crop?: boolean;
      denoise_steps?: number;
      seed?: number;
    } = {}
  ) {
    try {
      console.log('Starting try-on process', { garmentUri, modelUri, options });

      // Kiểm tra file tồn tại
      const garmentInfo = await FileSystem.getInfoAsync(garmentUri);
      const modelInfo = await FileSystem.getInfoAsync(modelUri);
      if (!garmentInfo.exists || !modelInfo.exists) {
        throw new Error(`Image file not found: garment=${garmentInfo.exists}, model=${modelInfo.exists}`);
      }

      // Tạo FormData
      const formData = new FormData();

      // Thêm file
      formData.append('user_image', {
        uri: modelUri,
        name: `model_${Date.now()}.jpg`,
        type: 'image/jpeg',
      } as any);

      formData.append('product_image', {
        uri: garmentUri,
        name: `garment_${Date.now()}.jpg`,
        type: 'image/jpeg',
      } as any);

      // Chuẩn bị tham số khớp với schema TryOnRequest
      const params = {
        ref_acceleration: options.is_checked === false ? 'false' : 'true', // Chuỗi "true"/"false" để FastAPI parse thành bool
        step: (options.denoise_steps || 30).toString(),                   // Chuỗi số nguyên
        scale: (2.5).toString(),                                          // Chuỗi số thực
        seed: (options.seed || 42).toString(),                            // Chuỗi số nguyên
        vt_model_type: 'viton_hd',                                        // Chuỗi
        vt_garment_type: 'upper_body',                                    // Chuỗi
        vt_repaint: 'false',                                              // Chuỗi "true"/"false" để FastAPI parse thành bool
      };

      // Thêm tham số vào FormData
      Object.entries(params).forEach(([key, value]) => {
        formData.append(key, value);
      });

      console.log('Chuẩn bị gửi yêu cầu tới API:', {
        url: `${API_URL}/tryon/`,
        files: { user_image: modelUri, product_image: garmentUri },
        params,
      });

      // Gửi yêu cầu
      const response = await axios.post(`${API_URL}/tryon/`, formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
        timeout: 360000, // 6 phút
      });

      console.log('API Response:', response.data);

      if (!response.data || typeof response.data.result_url !== 'string') {
        throw new Error('Invalid API response structure');
      }

      return response.data;

    } catch (error: any) {
      console.error('Error in processTryOn:', error);
      if (axios.isAxiosError(error)) {
        const status = error.response?.status;
        const errorDetail = error.response?.data?.detail || error.message;
        console.error('Axios error details:', { status, errorDetail });
        throw new Error(`Không thể xử lý yêu cầu: ${errorDetail} (Status: ${status})`);
      } else {
        throw new Error(`Lỗi bất ngờ: ${error.message}`);
      }
    }
  },
};

export const agentService = {
  async sendTextMessage(message: string, userId?: string) {
    try {
      const response = await axios.post(`${API_URL}/stylemate/query`, {
        query: message,
        user_id: userId || undefined
      }, {
        headers: {
          'Content-Type': 'application/json',
        },
      });

      return response.data;
    } catch (error: any) {
      console.error('Error in sendTextMessage:', error);
      if (axios.isAxiosError(error)) {
        const status = error.response?.status;
        const errorDetail = error.response?.data?.detail || error.message;
        console.error('Axios error details:', { status, errorDetail });
        throw new Error(`Could not process message: ${errorDetail} (Status: ${status})`);
      } else {
        throw new Error(`Unexpected error: ${error.message}`);
      }
    }
  },

  async sendMessageWithImage(message: string, imageUri: string) {
    try {
      // Check if file exists
      const imageInfo = await FileSystem.getInfoAsync(imageUri);
      if (!imageInfo.exists) {
        throw new Error(`Image file not found: ${imageUri}`);
      }

      // Create FormData
      const formData = new FormData();
      formData.append('query', message);
      formData.append('image_file', {
        uri: imageUri,
        name: `image_${Date.now()}.jpg`,
        type: 'image/jpeg',
      } as any);

      const response = await axios.post(`${API_URL}/stylemate/query-with-image`, formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      });

      return response.data;
    } catch (error: any) {
      console.error('Error in sendMessageWithImage:', error);
      if (axios.isAxiosError(error)) {
        const status = error.response?.status;
        const errorDetail = error.response?.data?.detail || error.message;
        console.error('Axios error details:', { status, errorDetail });
        throw new Error(`Could not process message with image: ${errorDetail} (Status: ${status})`);
      } else {
        throw new Error(`Unexpected error: ${error.message}`);
      }
    }
  },

  async resetConversation(userId?: string) {
    try {
      const response = await axios.post(`${API_URL}/stylemate/reset`, {
        user_id: userId || undefined
      });
      
      return response.data;
    } catch (error: any) {
      console.error('Error in resetConversation:', error);
      if (axios.isAxiosError(error)) {
        const status = error.response?.status;
        const errorDetail = error.response?.data?.detail || error.message;
        console.error('Axios error details:', { status, errorDetail });
        throw new Error(`Could not reset conversation: ${errorDetail} (Status: ${status})`);
      } else {
        throw new Error(`Unexpected error: ${error.message}`);
      }
    }
  }
};
