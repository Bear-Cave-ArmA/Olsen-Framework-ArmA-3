

FNC_DIA_GridSpottingFiremissionOpenDialog =
{
	_ok = createDialog "DIA_GridSpottingFiremission";
	[GSFM_DIA_IDC_GUNSELECT,GSFM_DIA_IDC_SHELLSELECT] call FNC_ArtLoadAviableArtilleries;
};

FNC_DIA_GridSpottingFiremissionSetArtillery =
{
	[GSFM_DIA_IDC_SHELLSELECT,_this] call FNC_ArtSetArtillery;
};

FNC_DIA_GridSpottingFiremissionCloseDialog =
{
	_ok = closeDialog GSFM_DIA_IDD_DISPLAY;

};

FNC_DIA_GridSpottingFiremissionFire =
{
	private _guns = player getVariable ["PlayerArtilleryGuns",[]];
	private _usableGuns = [];
	{
		if(alive _x && !(_x getVariable ["isInAFiremission",false])) then
		{
			_usableGuns pushBack _x;
		};
	}forEach _guns;
	private _selectedUnit = objNull;
	 if((count _usableGuns) > 0) then { _selectedUnit = (_usableGuns select (lbCurSel GSFM_DIA_IDC_GUNSELECT));};
	private _selectedAmmo = lbCurSel GSFM_DIA_IDC_SHELLSELECT;
	private _grid = 	ctrlText GSFM_DIA_IDC_GRID;
	if(_selectedUnit isEqualTo objNull) then  {hint "No Arty selected/aviable";}
	else
	{
		hint (([_selectedUnit,[_grid,true] call CBA_fnc_mapGridToPos,_selectedAmmo] call FNC_GetGridSpottingFiremissionText)
								+ "Requested by: " + (name player));
					["CallGridSpottingFiremission", [player,_selectedUnit,_grid,_selectedAmmo]] call CBA_fnc_serverEvent;
		[] call FNC_DIA_GridSpottingFiremissionCloseDialog;

	};



};

FNC_DIA_Server_GridSpottingFiremissionFire =
{
	private _requester  = _this select 0;
	private	_selectedUnit = _this select 1;
	private _grid = _this select 2;
	private _selectedAmmo = _this select 3;
	private _guns = _requester getVariable ["PlayerArtilleryGuns",[]];

	[_selectedUnit,_requester] call FNC_SetArtyCaller;
	[_selectedUnit,[_grid,true] call CBA_fnc_mapGridToPos,_selectedAmmo]   call FNC_GridSpottingFiremission;

};
if(isServer) then {_id = ["CallGridSpottingFiremission", {_this call FNC_DIA_Server_LineFiremissionFire;}] call CBA_fnc_addEventHandler;};
