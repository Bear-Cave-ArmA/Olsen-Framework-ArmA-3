
#include "defs.hpp"

FNC_GetCompleteInfoText =
{
	private _unit = _this;
	private _rounds = _unit call FNC_GetArtyFiremissionRoundsRequired;
	private _callerName = _unit call FNC_GetArtyCallerText;
	private _fireMissionText =_unit getVariable ["ArtyFiremissionText","Error"];
	private _ret = _fireMissionText +"Rounds fired: " + (str (_rounds select 0)) + "/" + (str (_rounds select 1)) + "\nRequested by: " + (_unit call FNC_GetArtyCallerText);
	_ret;
};
FNC_SetArtyReadyStatus =
{
	private _unit = _this select 0;
	private _isFiring = _this select 1;

	_unit setVariable ["isInAFiremission",_isFiring,true];
	["Event_ArtyIsReady", [_unit,_isFiring]] call CBA_fnc_globalEvent;
};
FNC_GetArtyFiremissionRoundsRequired =
{
	private _unit = _this;
	private _ret = _unit getVariable ["ArtyFiremissionRoundsFired",[0,0]];
	_ret
};
FNC_GetArtyAimTime =
{
	private _unit = _this;
	private _ret = ((_unit getVariable ["ArtAimSpeed",MEANAIMTIME]) + 1);
	_ret
};

FNC_GetArtyCalcTime =
{
	private _unit = _this;
	private _ret = ((_unit getVariable ["ArtCalcSpeed",MEANAIMTIME]) + 1);
	_ret
};

FNC_GetArtyEta =
{
	private _unit = _this select 0;
	private _pos = _this select 1;
	private _ammo = _this select 2;
	private _ret = _unit getArtilleryETA [_pos, _ammo];
	_ret
};
FNC_SetArtyFiremissionRoundsRequired =
{
	private _unit = _this select 0;
	private _roundsFired = _this select 1;
	private _roundsRequired = _this select 2;
	_unit setVariable ["ArtyFiremissionRoundsFired",[_roundsFired,_roundsRequired],true];

};

FNC_GetArtyCaller =
{
	private _unit = _this;
	private _callerUnit = _unit getVariable ["ArtyCaller",objNull];
	_callerUnit
};
FNC_GetArtyCallerText =
{
	private _unit = _this;
	private _caller = _unit call FNC_GetArtyCaller;
	private _returnName = "Non specified";
	if(!(isNull  _caller)) then
	{
		_returnName = name _caller;
	};

	_returnName
};
FNC_SetArtyCaller =
{
	private _unit = _this select 0;
	private _caller = _this select 1;
	_unit setVariable ["ArtyCaller",_caller,true];
};

FNC_GetArtyDisplayName =
{
	private _unit = _this;
	private	_text = _unit getVariable ["ArtCustomName",""];
	if(_text == "") then { _text = getText (configfile / "CfgVehicles" /  typeOf(_unit) / "displayName") };
	_text
};

FNC_GetArtyAmmo =
{
	private _unit =_this;
	private _ammo = magazinesAmmo _unit;
	private _ret = [];
	{
		_check = _x;
		_found = false;
		{
			if(_x select 0 == _check select 0) then
			{
				_found = true;
				_num = (_check select 1) + (_x select 1);
				_x set [1,_num];
			}
		}forEach _ret;
		if(!_found) then
		{
			_ret pushBack [_x select 0,_x select 1];
		};

	}forEach _ammo;
	_ret
};

FNC_ArtLoadAviableArtilleries =
{
			private _id = _this select 0;
			private _shellSelect = _this select 1;
			private _guns = player getVariable ["PlayerArtilleryGuns",[]];
			private _usableGuns = [];
			{
				if(alive _x && !(_x getVariable ["isInAFiremission",false])) then
				{
					_usableGuns pushBack _x;
				};
			}forEach _guns;


			lbClear _id;
			{
				lbAdd [_id,_x call FNC_GetArtyDisplayName];

			}forEach _usableGuns;
			lbSetCurSel [_id,0];
};
FNC_ArtSetArtillery =
{
	private _id = _this select 0;
	private _gun = _this select 1;
	if(_gun >= 0) then
	{
		_guns = player getVariable ["PlayerArtilleryGuns",[]];
		_usableGuns = [];
		{
			if(alive _x && !(_x getVariable ["isInAFiremission",false])) then
			{
				_usableGuns pushBack _x;
			};
		}forEach _guns;
		_actualGunUnit = _usableGuns select _gun;

		_ammo = _actualGunUnit call FNC_GetArtyAmmo;

		{
			_text = (str (_x select 1)) + "x " + getText (configfile / "CfgMagazines" / (_x select 0) / "displayName");
			lbAdd [_id, _text];

		}forEach _ammo;
		lbSetCurSel [_id,0];
	}
};
