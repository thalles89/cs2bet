import { Routes } from '@angular/router';
import { LoginComponent } from './login/login.component';
import { DisputeComponent } from './dispute/dispute.component';
import { RulesComponent } from './rules/rules.component';

export const routes: Routes = [
    {
        path: 'login',
        component: LoginComponent
    },
    {
        path: 'dispute',
        component: DisputeComponent
    },
    {
        path: 'about',
        component: RulesComponent
    }
];
