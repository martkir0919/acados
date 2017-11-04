/*
 *    This file is part of acados.
 *
 *    acados is free software; you can redistribute it and/or
 *    modify it under the terms of the GNU Lesser General Public
 *    License as published by the Free Software Foundation; either
 *    version 3 of the License, or (at your option) any later version.
 *
 *    acados is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *    Lesser General Public License for more details.
 *
 *    You should have received a copy of the GNU Lesser General Public
 *    License along with acados; if not, write to the Free Software Foundation,
 *    Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 */


#ifndef ACADOS_DENSE_QP_DENSE_QP_QPOASES_EXT_DEP_H_
#define ACADOS_DENSE_QP_DENSE_QP_QPOASES_EXT_DEP_H_

#ifdef __cplusplus
extern "C" {
#endif

// acados
#include "acados/dense_qp/dense_qp_common.h"
#include "acados/dense_qp/dense_qp_qpoases.h"

dense_qp_qpoases_args *dense_qp_qpoases_create_arguments(dense_qp_in *qp_in);

dense_qp_qpoases_memory *dense_qp_qpoases_create_memory(dense_qp_in *qp_in, void *args_);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif  // ACADOS_DENSE_QP_DENSE_QP_QPOASES_EXT_DEP_H_
