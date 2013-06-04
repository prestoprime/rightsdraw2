/*#  rightsdraw
#  Version: 2.0.1
#  Authors: L. Boch
#
#  Copyright (C) 2010-2013 RAI – Radiotelevisione Italiana <cr_segreteria@rai.it>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
function incperc(fn,en){

	var a;
	var b;
	a=document.forms[fn].elements[en].value;
	if (a=="") {
		b=50;
	}
	else if ( a=="null") {
		b=50;
	}
	else { 
		b = Number(a);
		if (b>= 100) {
			b=0;
		}
		else if (b>= 90) {
			b=100;
		}
		else {
			b +=10;
		}
	}
	document.forms[fn].elements[en].value=parseInt(b);
}
function decperc(fn,en){
	var a;
	var b;
	a=document.forms[fn].elements[en].value;
	if (a!="") {
		b = Number(a);
	}
	if (b == 0) {
		document.forms[fn].elements[en].value="null";
	}
	else if (b > 0 ) {
		b=b-1;
		document.forms[fn].elements[en].value=parseInt(b);
	}
}
