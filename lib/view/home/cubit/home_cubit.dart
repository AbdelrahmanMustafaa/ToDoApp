import 'package:bloc/bloc.dart';
import 'package:firebasetest/model/const_values/const_values.dart';
import 'package:firebasetest/model/grateful_model/grateful_model.dart';
import 'package:firebasetest/model/shared_model/shared_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controller/database_handler.dart';
import '../../../model/tasks_model/task_model.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  String mainEmotion = 'Images/Neutral Face Emoji.png';
  String happyEmoji = 'Images/Smiling Emoji with Smiling Eyes.png';
  String sadEmoji = 'Images/Disappointed Face Emoji.png';
  String neutralEmoji = 'Images/Neutral Face Emoji.png';

  TextEditingController valueController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController gratefulController = TextEditingController();

  void realTimeChange(String value) {
    gratefulController.text = value;
    emit(RealTimeChangeState());
  }

  void changeEmoji(String emoji) {
    mainEmotion = emoji;
    if (emoji == happyEmoji) {}
    emit(ChaneEmojiState());
    print(mainEmotion);
  }

  String checkBoxValue = false.toString();

  String changeCheckBox(String value) {
    checkBoxValue = value;
    emit(ChangeCheckBox());
    return checkBoxValue;
  }

  DatabaseHandler? databaseHandler = DatabaseHandler.instance;
  List<TaskModel> tasksList = [];

  Future<List<TaskModel>> getTasks() async {
    tasksList = await databaseHandler!.getAllTasks();
    print('Tasks Count ${tasksList.length}');
    putDatabaseNameToShared(databaseName);
    return tasksList;
  }

  updateDays (String)async {
     getTasks();
    emit(UpdateDaysState());
  }

  Future<void> addTask(TaskModel userModel) async {
    print('Add Task ${userModel.toMap()}');
    print(
        '========================================================================================');
    await databaseHandler!.createTask(userModel);

    emit(AddUserState());
  }

  updateTask(TaskModel userModel) async {
    print('Update Task ${userModel.toMap()}');
    print(
        '========================================================================================');
    await databaseHandler!.updateTask(userModel);
    emit(UpdateTaskState());
  }

  deleteTask(int id) async {
    print('Delete Task $id');
    print(
        '========================================================================================');
    await databaseHandler!.deleteTask(id);
    emit(DeleteTaskState());
  }

  /*========================================================================================*/
  // grateful

  List<GratefulModel> listGrateful = [];

  Future<List<GratefulModel>> getGrateful() async {
    listGrateful = await databaseHandler!.getAllGrateful();
    print('Grateful Count ${listGrateful.length}');

    return listGrateful;
  }

  Future<void> addGrateful(GratefulModel gratefulModel) async {
    print('Add Grateful ${gratefulModel.toMap()}');
    print(
        '========================================================================================');
    await databaseHandler!.createGrateful(gratefulModel);
    emit(AddGratefulState());
  }

  updateGrateful(GratefulModel gratefulModel) async {
    print('Update Grateful ${gratefulModel.toMap()}');
    print(
        '========================================================================================');
    await databaseHandler!.updateGrateful(gratefulModel);
    emit(UpdateGratefulState());
  }

  deleteGrateful(int id) async {
    print('Delete Grateful $id');
    print(
        '========================================================================================');
    await databaseHandler!.deleteGrateful(id);
    emit(DeleteGratefulState());
  }



  putDatabaseNameToShared(String databaseName) async {
    List finalName = databaseName.split('.');
    print (finalName[0]);
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(finalName[0], finalName[0]).then((value) {
      print('add data to shared done');

      print(pref.getKeys());
    });
  }


  Future<List<SharedModel>> getInPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    Set<String> maps = await pref.getKeys();
    print(
        '=======================================================================');
    print(
        '=======================================================================');
    print(' names ${maps.length} Values : $maps');
    emit(GetInPrefState());
    return maps.isNotEmpty ? maps.map((e) => SharedModel(name: e)).toList() :
    [];
  }

  putModeToShared(String mode) async {
    List<String>? finalName = [];
    if(mode == 'Images/Smiling Emoji with Smiling Eyes.png' )
      {
        finalName[0]= 'happy';
      }
    else if ( mode =='Images/Neutral Face Emoji.png' )
      {
        finalName[0] = 'normal';
      }
    else if ( mode == 'Images/Disappointed Face Emoji.png' )
      {
        finalName[0] = 'sad' ;
      }

    print ('----------------------put mode-------------------------------');
    print (finalName[0]);
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('mode$databaseName', finalName[0]).then((value) {
      print('add Mode to shared done');

      print(pref.getKeys());
    });
  }


}
