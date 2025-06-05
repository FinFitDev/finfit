part of 'steps_controller.dart';

extension StepsControllerMutations on StepsController {
  reset() {
    IStoreStepsData newSteps = {};
    _userSteps.add(ContentWithLoading(content: newSteps));
  }

  addUserSteps(IStoreStepsData activity) {
    IStoreStepsData newSteps = {...userSteps.content, ...activity};
    _userSteps.add(ContentWithLoading(content: newSteps));
  }

  setStepsLoading(bool loading) {
    userSteps.isLoading = loading;
    _userSteps.add(userSteps);
  }
}
