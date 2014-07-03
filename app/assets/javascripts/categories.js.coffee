# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class @Utils

  @replaceContainerWith: (container, pageUrl) ->
    $.ajax
      type: "GET"
      cache: false
      url: pageUrl
      dataType: "JSON"
      success: (res) ->
        container.html res.html
      error: (xhr, ajaxOptions, thrownError) ->
        msg = "Error on reloading the content. Please check your connection and try again."
        toastr.warning(msg)
        console.log(msg)

  @makeRequest: (requestUrl, requestMethod, requestData = null, modalForm = null) ->
    $.ajax(
      url: requestUrl
      data: requestData
      dataType: "JSON"
      method: requestMethod
    ).done((json) ->
      toastr.success(json.message)
      modalForm.modal('hide') if modalForm
    ).fail (xhr) ->
      response = JSON.parse(xhr.responseText)
      toastr.error(response.message)
      modalForm.html(response.html) if modalForm && response.html



class @Form
  _form = null
  _container = null
  _loadUrl = null
  _modal = null
  _form = null

  _handleModalForm = ->
    _form.submit ->
      return false
    _modal.find('button.ajax-submit').click ->
      $.ajax(
        url: _form.attr("action")
        data: _form.serialize()
        dataType: "JSON"
        method: _form.attr("method")
      ).done((json) ->
        toastr.success(json.message)
        _modal.modal('hide') if _modal
        Utils.replaceContainerWith(_container, _loadUrl)
      ).fail (xhr) ->
        response = JSON.parse(xhr.responseText)
        toastr.error(response.message)
        _modal.html(response.html) if _modal && response.html



  @init: (containerSelector, modalSelector) ->
    _container = $(containerSelector)
    _loadUrl = _container.attr('data-load-url')
    _modal = $(modalSelector)
    _form = _modal.find("form")
    _handleModalForm()





class @Tree
  _modal = null
  _container = null
  _loadUrl = null
  _tree = null
  _actionButton = null
  _searchInput = null

  _loadModal = (url) ->
    _modal.empty()
    $('body').modalmanager('loading')

    $.ajax
      type: "GET",
      cache: false,
      url: url,
      dataType: "json",
      success: (res) ->
        $('body').modalmanager('loading')
        _modal.html(res.html)
        _modal.modal()
      error: (xhr, ajaxOptions, thrownError) ->
        $('body').modalmanager('loading')

  _doRequest = (url, method = null, callBackArg, callBack) ->

    if method == null || method.toLowerCase() == 'get'
      _loadModal(url);
    else
      Utils.makeRequest(url, method, null, null, callBackArg, callBack)
      Utils.replaceContainerWith(_container, _loadUrl)


  @init: (treeAjaxSource, treeSelector, modalSelector, containerSelector, actionSelector, searchSelector) ->
    _modal = $(modalSelector)
    _container = $(containerSelector)
    _loadUrl = _container.attr('data-load-url')
    _actionButton = $(actionSelector)
    _searchInput = $(searchSelector)
    console.log(_searchInput)
    _tree = $(treeSelector).jstree(
      core:
        themes:
          responsive: false

        check_callback: true

        data:
          url: (node) ->
            treeAjaxSource

      types:
        folder:
          icon: "fa fa-folder icon-success icon-lg"
        subfolder:
          icon: "fa fa-folder icon-warning icon-lg"
        file:
          icon: "fa fa-file icon-danger icon-lg"
      state:
        key: "categories"

      plugins: [ "contextmenu", "dnd", "types", "sort", "search", "state"]

      dnd:
        copy: false




      contextmenu:
        items: (_node) ->
          nodeData = _node.data
          New:
            id: "1"
            label: "New"
            icon: "glyphicon glyphicon-plus"
            separator_after: true
            action: ->
              url = nodeData.crud.new.url
              method = nodeData.crud.new.method
              _doRequest(url, method)
          Edit:
            id: "2"
            label: "Edit"
            icon: "glyphicon glyphicon-plus"
            separator_after: true
            action: ->
              url = nodeData.crud.edit.url
              method = nodeData.crud.edit.method
              _doRequest(url, method)

          Delete:
            id: "3"
            label: "Delete"
            icon: "glyphicon glyphicon-plus"
            separator_after: true
            action: ->
              url = nodeData.crud.delete.url
              method = nodeData.crud.delete.method
              if (confirm("Are you sure ?") == true)
                _doRequest(url, method, _node, ((node) -> _tree.jstree('delete_node', node)))





    )


    _tree.bind "move_node.jstree", ( e, data ) ->
      node = data.node
      nodeParentId = data.parent
      moveRequestData = {category: {parent_id: nodeParentId} }
      Utils.makeRequest(node.data.crud.move.url, node.data.crud.move.method, moveRequestData)
      Utils.replaceContainerWith(_container, _loadUrl)


    _tree.bind "loaded.jstree", ( e, data ) ->
      _actionButton.click ->
        actionUrl = $(@).attr('data-action-url')
        _doRequest(actionUrl)

      _searchInput.keyup ->
        _tree.jstree("search", $(@).prop('value'))


    _tree.bind "delete_node.jstree", ( e, data ) ->
      console.log(data)
      console.log('delete')

    _tree.bind "create_node.jstree", ( e, data ) ->
      console.log(data)
      console.log('create')









