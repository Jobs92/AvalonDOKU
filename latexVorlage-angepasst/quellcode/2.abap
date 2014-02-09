method HANDLEDEFAULT .

  wd_this->ORIGIN = ORIGIN.

  DATA lt_buffer TYPE TABLE OF ZMATSTR_DETAIL_JGO.
  DATA ls_result TYPE ZMATSTR_DETAIL_JGO.

  DATA lo_nd_basic TYPE REF TO if_wd_context_node.


  DATA lo_el_basic TYPE REF TO if_wd_context_element.
  DATA ls_basic TYPE wd_this->Element_basic.
  DATA lv_matnr TYPE wd_this->Element_basic-matnr.

* navigate from <CONTEXT> to <BASIC> via lead selection
  lo_nd_basic = wd_context->get_child_node( name = wd_this->wdctx_basic ).


* get element via lead selection
  lo_el_basic = lo_nd_basic->get_element( ).
* @TODO handle not set lead selection
  IF lo_el_basic IS INITIAL.
  ENDIF.

* get single attribute
  lo_el_basic->get_attribute(
    EXPORTING
      name =  `MATNR`
    IMPORTING
      value = lv_matnr ).

*  CALL METHOD ZBO_1_JGO=>RETRIEVE
*    IMPORTING
*      ET_BUFFER = lt_buffer
*      .

  DATA lt_node_id TYPE /PLMB/T_MAT_ID.
  DATA ls_node_id TYPE /PLMB/S_MAT_ID.
  DATA lt_node_data TYPE TABLE OF ZMATSTR_DETAIL_JGO.
  DATA lv_failed TYPE /PLMB/SPI_FAILED_IND.

  ls_node_id-MATNR = lv_matnr.

 APPEND ls_node_id TO lt_node_id.

    CALL METHOD WD_COMP_CONTROLLER->MO_APPMODEL->RETRIEVE
      exporting
        IV_NODE_NAME        =    'DETAIL' " Node name
*        IV_TARGET_NODE_NAME =     " Node name
        IT_NODE_ID          = lt_node_id
*        IV_LOCK             =     " Locking indicator
*        IT_REQUESTED_FIELD  =     " Requested Fields of Node Data
      importing
         EV_FAILED           =    lv_failed " Index of node ID for which no data is available
*        ET_INDEX_FAILED     =     " Index of node ID for which no data is availab
         ET_NODE_DATA        =    lt_node_data " Node ID and node data
*        ET_NODE_ID_REL      =     " Relationship between index of source and target node ID
      .
    IF lV_FAILED = 'X'.

  CASE ORIGIN.

    WHEN 'm'.
        wd_this->fire_back_plg(
        ).
    WHEN 'o'.
        wd_this->fire_backtooverview_plg(
        ).
        ENDCASE.
      ENDIF.

*lt_node_data liefert das Ergebnis

*IF lv_failed = 'X'.
*
** get message manager
*data lo_api_controller     type ref to if_wd_controller.
*data lo_message_manager    type ref to if_wd_message_manager.
*
*lo_api_controller ?= wd_This->Wd_Get_Api( ).
*
*CALL METHOD lo_api_controller->GET_MESSAGE_MANAGER
*  RECEIVING
*    MESSAGE_MANAGER = lo_message_manager
*    .
*
** report message
*CALL METHOD lo_message_manager->REPORT_MESSAGE
*  EXPORTING
*    MESSAGE_TEXT              = 'MATNR existiert nicht'
**    MESSAGE_TYPE              = CO_TYPE_ERROR
**    PARAMS                    =
**    MSG_USER_DATA             =
**    IS_PERMANENT              = ABAP_FALSE
**    SCOPE_PERMANENT_MSG       = CO_MSG_SCOPE_CONTROLLER
**    VIEW                      =
**    SHOW_AS_POPUP             =
**    CONTROLLER_PERMANENT_MSG  =
**    MSG_INDEX                 =
**    CANCEL_NAVIGATION         =
**    ENABLE_MESSAGE_NAVIGATION =
**    COMPONENT                 =
**  RECEIVING
**    MESSAGE_ID                =
*    .
*
*
*
*  ENDIF.


*
***********************
*  DATA lo_nd_detail TYPE REF TO if_wd_context_node.
*
*  DATA lo_el_detail TYPE REF TO if_wd_context_element.
**  DATA ls_detail TYPE ZMATSTR_DETAIL_JGO.
*
** navigate from <CONTEXT> to <DETAIL> via lead selection
*  lo_nd_detail = wd_context->get_child_node( name = wd_this->wdctx_detail ).
*
** @TODO handle non existant child
** IF lo_nd_detail IS INITIAL.
** ENDIF.
*
** get element via lead selection
*  lo_el_detail = lo_nd_detail->CREATE_ELEMENT( ).
*
*** lo_el_detail = lo_nd_detail->get_element( ).
*
** alternative access  via index
** lo_el_detail = lo_nd_detail->get_element( index = 1 ).
*
** @TODO handle not set lead selection
*  IF lo_el_detail IS INITIAL.
*  ENDIF.
*
** @TODO fill static attributes
** ls_detail = xxx->get_yyy( ).
*
** set all declared attributes
*  lo_el_detail->set_static_attributes(
*     static_attributes = ls_result ).
*
*
*


endmethod.