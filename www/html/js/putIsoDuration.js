/*
#  rightsdraw
#  Version: 2.0.1
#  Authors: L. Boch
#
#  Copyright (C) 2010-2012 RAI – Radiotelevisione Italiana <cr_segreteria@rai.it>
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
function putIsoDur(fn,en){
	if (opener && !opener.closed) {
		opener.document.forms[fn].elements[en].value='P'+document.isodur.y.value+'Y'+document.isodur.mo.value+'M'+document.isodur.d.value+'DT'+document.isodur.h.value+'H'+document.isodur.mi.value+'M'
	}
}
function nullIsoDur(fn,en){
	if (opener && !opener.closed) {
		opener.document.forms[fn].elements[en].value="null";
	}
}
