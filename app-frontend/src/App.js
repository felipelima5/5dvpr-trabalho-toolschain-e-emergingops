
import './App.css';
import "primereact/resources/themes/lara-light-cyan/theme.css";

import React from 'react'; 
import { Menubar } from 'primereact/menubar';

export default function UnstyledDemo() {
    const items = [
        {
            label: 'Membros da Equipe',
            icon: 'pi pi-fw pi-file',
            items: [
                {
                    label: 'Felipe Lima Silva',
                    icon: 'pi pi-fw pi-trash'
                },
                {
                  label: 'Adriano Silva',
                  icon: 'pi pi-fw pi-trash'
                },
                {
                  label: 'Giuliano Cintra',
                  icon: 'pi pi-fw pi-trash'
                },
                {
                    separator: true
                },
                {
                  label: 'Sair',
                  icon: 'pi pi-fw pi-trash'
                }
            ]
        },
        {
            label: 'Turma',
            icon: 'pi pi-fw pi-pencil',
            items: [
                {
                    label: '5DVPR',
                    icon: 'pi pi-fw pi-align-left'
                }
            ]
        },
        {
            label: 'Curso',
            icon: 'pi pi-fw pi-user',
            items: [
                {
                    label: 'DevOps & Reliability Engineering',
                    icon: 'pi pi-fw pi-user-plus',

                } 
            ]
        },
        {
            label: 'Quit',
            icon: 'pi pi-fw pi-power-off'
        }
    ];

    return (
        <div className="card">
            <Menubar model={items} />
        </div>
    )
}

