import { Component } from '@angular/core';
import { MatButton } from '@angular/material/button';
import {MatCardModule} from '@angular/material/card';
import { MatIcon } from '@angular/material/icon';
import {MatProgressBarModule} from '@angular/material/progress-bar';
import {MatDividerModule} from '@angular/material/divider';


@Component({
  selector: 'app-dispute',
  standalone: true,
  imports: [MatCardModule, MatButton, MatIcon, MatProgressBarModule, MatDividerModule],
  templateUrl: './dispute.component.html',
  styleUrl: './dispute.component.scss'
})
export class DisputeComponent {

}
