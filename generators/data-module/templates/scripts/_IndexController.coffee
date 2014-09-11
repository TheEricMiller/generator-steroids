<%= resourceName %>App = angular.module("<%= resourceName %>App", ["<%= _.capitalize(resourceName) %>Model"])

<%= resourceName %>App.controller("IndexCtrl", [
  "$scope"
  "<%= _.capitalize(resourceName) %>Resource"
  ($scope, <%= _.capitalize(resourceName) %>Resource)->

    $scope.<%= resourceName %>s = []
    $scope.showSpinner = true

    # Helper function for opening new webviews
    $scope.open = (id)->
      webView = new steroids.views.WebView "/views/<%= resourceName %>/show.html?id=#{id}"
      steroids.layers.push webView

    $scope.showModal = ->
      webView = new steroids.views.WebView "/views/<%= resourceName %>/new.html"
      steroids.modal.show webView

    fetchResources = ->
      $scope.showSpinner = true
      <%= _.capitalize(resourceName) %>Resource.findAll().then (<%= resourceName %>s)->
        $scope.$apply ->
          $scope.<%= resourceName %>s = <%= resourceName %>s
          $scope.showSpinner = false

    # Trigger data refresh when this view becomes visible
    steroids.data.reactive.whenVisible.onValue ->
      fetchResources()

    # Native navigation
    steroids.view.navigationBar.show "<%= _.capitalize(resourceName) %>s"
    steroids.view.setBackgroundColor "#FFFFFF"

  ])