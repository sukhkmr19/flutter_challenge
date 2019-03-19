import 'package:flutter_app_challenge/models/UserData.dart';
import 'package:flutter_app_challenge/resources/Repository.dart';
import 'package:rxdart/rxdart.dart';

class FetchJsonBloc {
  final _repository = Repository();
  final _listFetcher = PublishSubject<UserData>();

// For state, exposing only a stream which outputs data
  Observable<UserData> get allData => _listFetcher.stream;

  fetchAllUserData() async {
    UserData itemModel = await _repository.fetchAllData();
    // For events, exposing only a sink which is an input
    _listFetcher.sink.add(itemModel);
  }

  dispose() {
    _listFetcher.close();
  }
}

final bloc = FetchJsonBloc();
