#include "script_component.hpp"

params ["_group"];

private _getAttackStatus = units _group findIf {
    getAttackTarget vehicle _x isNotEqualTo objNull
} isNotEqualTo -1;

if !(_getAttackStatus) then {
    private _targets = _group targets [true];
    if (_targets isEqualTo []) then {
        allGroups select {
            (GETVAR(_x,Spawned,false)) &&
            {!isNull leader _x} &&
            {alive leader _x} &&
            {!(GETVAR(leader _x,NOAI,false))} &&
            {!(GETVAR(_x,NOAI,false))} &&
            {!(isPlayer leader _x)} && 
            {side _x isEqualTo side _group} &&
            {leader _x distance2D leader _group <= 300}
        } apply {
            if (
            (units _x findIf {
                getAttackTarget vehicle _x isNotEqualTo objNull 
            } isNotEqualTo -1) || 
            {_x targets [true] isNotEqualTo []}
            ) exitWith {
                _getAttackStatus = true;
            };
        };
    } else {
        _getAttackStatus = true;
    };
};

_getAttackStatus