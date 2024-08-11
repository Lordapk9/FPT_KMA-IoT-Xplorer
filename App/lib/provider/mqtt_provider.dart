// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:home_iot_device/model/smart_home_model.dart';
// import 'package:home_iot_device/service/mqtt_service.dart';
//
// final apiServiceProvider = Provider<MqttService>((ref) => MqttService());
//
// // Tạo StateProvider để quản lý danh sách đối tượng
// // final personsProvider = StateProvider<List<Person>>((ref) => initialPersons);
//
// // Tạo FutureProvider để kiểm tra và cập nhật danh sách từ API
// final updatedPersonsProvider = FutureProvider<List<DeviceInRoom>>((ref) async {
//   final apiService = ref.watch(apiServiceProvider);
//   final updatedPersons = await apiService.connect();
//   return updatedPersons;
// });