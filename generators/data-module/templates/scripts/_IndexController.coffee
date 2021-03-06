angular
  .module('<%= moduleName %>')
  .controller("IndexController", ($scope, <%= _.capitalize(resourceName) %>, supersonic) ->
    $scope.<%= resourceName %>s = null
    $scope.showSpinner = true

    <%= _.capitalize(resourceName) %>.all().whenChanged (<%= resourceName %>s) ->
      $scope.$apply ->
        $scope.<%= resourceName %>s = <%= resourceName %>s
        $scope.showSpinner = false
  )